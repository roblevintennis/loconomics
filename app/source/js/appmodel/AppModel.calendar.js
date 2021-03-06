/**
    It offers access to calendar elements (appointments) and availability
    
    Appointments is an abstraction around calendar events
    that behave as bookings or as events (where bookings are built
    on top of an event instance --a booking record must have ever a serviceDateID event).
    
    With this appModel, the APIs to manage events&bookings are combined to offer related
    records easier in Appointments objects.
**/
'use strict';

var Appointment = require('../models/Appointment'),
    DateAvailability = require('../models/DateAvailability'),
    DateCache = require('../utils/DateCache'),
    EventEmitter = require('events').EventEmitter;

exports.create = function create(appModel) {

    function Api() {
        EventEmitter.call(this);
        this.setMaxListeners(30);
    }
    Api._inherits(EventEmitter);
    
    var api = new Api();
    
    var cache = new DateCache({
        Model: DateAvailability,
        ttl: { minutes: 10 }
    });
    
    api.clearCache = function clearCache() {
        cache.clear();
        this.emit('clearCache');
    };
    
    appModel.on('clearLocalData', function() {
        api.clearCache();
    });

    /**
        Get a generic calendar appointment object, made of events and/or bookings,
        depending on the given ID in the ids object.
        
        TODO: gets single apt from the DateCache
    **/
    api.getAppointment = function getAppointment(ids) {

        if (ids.calendarEventID) {
            return appModel.calendarEvents.getEvent(ids.calendarEventID)
            .then(Appointment.fromCalendarEvent);
        }
        else if (ids.bookingID) {
            return appModel.bookings.getBooking(ids.bookingID)
            .then(function(booking) {
                // An appointment for booking needs the confirmed event information
                return appModel.calendarEvents.getEvent(booking.serviceDateID())
                .then(function(event) {
                    return Appointment.fromBooking(booking, event);
                });
            });
        }
        else {
            return Promise.reject('Unrecognized ID');
        }
    };
    
    api.setAppointment = function setAppointment(apt, allowBookUnavailableTime) {
        
        // TODO: Saving apt must invalidate the cache and force date
        // availability computation with UI update, when start time or start end changes 
        // (ever when inserting apt), for the previous date and the new one (if date changed)
        // and only date availability computation if date is the same but time changed.
        // And triggers "this.emit('clearCache');" passing as parameter the dates array that needs refresh
        
        // If is a booking
        if (apt.sourceBooking()) {
            return appModel.bookings.setServiceProfessionalBooking(apt, allowBookUnavailableTime)
            .then(function(booking) {
                
                // TODO: clearCache, enhance by discarding only the cache for the previous
                // and new date
                api.clearCache();
                
                // We need the event information too
                return appModel.calendarEvents.getEvent(booking.serviceDateID())
                .then(function(event) {
                    return Appointment.fromBooking(booking, event);
                });
            });
        }
        else if (apt.sourceEvent()) {
            return appModel.calendarEvents.setEvent(apt)
            .then(function(event) {
                return Appointment.fromCalendarEvent(event);
            });
        }
        else {
            return Promise.reject(new Error('Unrecognized appointment object'));
        }
    };
    
    /**
        Get a list of generic calendar appointment objects, made of events and/or bookings
        by Date, from the remote source directly.
        Used internally only, to get appointments with and without free/unavailable
        slots use getDateAvailability
    **/
    var getRemoteAppointmentsByDate = function getRemoteAppointmentsByDate(date) {
        return Promise.all([
            appModel.bookings.getBookingsByDates(date),
            appModel.calendarEvents.getEventsByDates(date)
        ]).then(function(group) {

            var events = group[1],
                bookings = group[0],
                apts = [];

            if (events && events().length) {
                apts = Appointment.listFromCalendarEventsBookings(events(), bookings());
            }

            // Return the array
            return apts;
        });
    };
    
    /**
        Fetch appointments and schedule information for the date from remote
        in a convenient object to use with the DateAvailability model.
    **/
    var getRemoteDateAvailability = function getRemoteDateAvailability(date) {
        return Promise.all([
            getRemoteAppointmentsByDate(date),
            appModel.weeklySchedule.load(),
            appModel.schedulingPreferences.load()
        ])
        .then(function(result) {
            var apts = result[0];
            var settings = result[1];
            var prefs = result[2];

            var dateInfo = {
                date: date,
                appointmentsList: apts || [],
                weeklySchedule: settings,
                schedulingPreferences: prefs
            };

            return dateInfo;
        });
    };
    
    /**
        Get the appointments and availability for the given date.
        It has cache control, if there is a valid copy is returned
        at the moment, if is reloaded and exists on cache, that copy is
        updated so all previous instances get the updated data too.
    **/
    api.getDateAvailability = function getDateAvailability(date) {
        var cached = cache.getSingle(date);

        if (cached) {
            return Promise.resolve(cached);
        }
        else {
            return getRemoteDateAvailability(date)
            .then(function(dateInfo) {
                // Update cache and retun data as class instance
                return cache.set(date, dateInfo).data;
            });
        }
    };

    return api;
};

