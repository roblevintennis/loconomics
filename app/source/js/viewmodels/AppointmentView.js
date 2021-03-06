/**
    Appointment View model that wraps an Appointment
    model instance extended with extra methods connected
    to related data
**/
'use strict';

var ko = require('knockout');

module.exports = function AppointmentView(appointment, app) {
    if (appointment._isAppointmentView) return appointment;
    appointment._isAppointmentView = true;

    appointment.client = ko.computed(function() {
        var b = this.sourceBooking();
        if (!b) return null;

        var cid = this.clientUserID();
        if (cid) {
            return app.model.clients.getObservableItem(cid, true)();
        }
        return null;
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 20 } });

    ko.computed(function() {
        var add = this.address();
        var aid = add && add.addressID(),
            jid = this.jobTitleID();
        if (aid && jid) {
            app.model.serviceAddresses.getItem(jid, aid).then(function(serverAddress) {
                if (serverAddress.addressID === aid)
                    add.model.updateWith(serverAddress, true);
            });
        }
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 20 } });

    appointment.addressSummary = ko.computed(function() {
        var eventData = this.sourceEvent();
        var add = this.address();
        return add && add.singleLineDetailed() || eventData && eventData.location() || '';
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 20 } });

    /* Property with the pricing array plus information about the
        serviceProfessionalService.
    */
    appointment.pricingWithInfo = ko.computed(function() {
        var b = this.sourceBooking();
        if (!b) return [];

        var jid = this.jobTitleID(),
            details = this.pricing();

        return details.map(function(det) {
            return pricingSummaryDetailView(det, jid, app);
        });
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 60 } });

    appointment.servicesSummary = ko.computed(function() {
        return this.pricingWithInfo()
        .map(function(service) {
            return service.serviceProfessionalService().name();
        }).join(', ');
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 20 } });

    /**
     * Calculates the total time needed for the appointment based on the
     * included services.
     * It fetches up-to-date data, waiting if needed for services to load.
     * @returns {Promise<Number>}
     */
    appointment.getServiceDurationMinutes = function() {
        var jid = this.jobTitleID();
        var pricing = this.pricing();
        if (!pricing) {
            return Promise.resolve(0);
        }
        var tasks = pricing.map(function(service){
            var id = service.serviceProfessionalServiceID();
            return app.model.serviceProfessionalServices.getItem(jid, id);
        });
        return Promise.all(tasks).then(function(services) {
            return services.reduce(function(prev, service) {
                return prev + service.serviceDurationMinutes;
            }, 0);
        });
    };

    // ServiceDuration as computed so can be observed for changes
    appointment.serviceDurationMinutes = ko.computed(function() {
        var pricing = this.pricingWithInfo();
        var sum = pricing.reduce(function(prev, service) {
            return prev + service.serviceProfessionalService().serviceDurationMinutes();
        }, 0);
        return sum;
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 20 } });

    ko.computed(function() {
        var pricing = appointment.pricing();
        if (pricing.length === 0) {
            this.price(0);
        }
        else {
            // double check the pricing object is right (sometimes comes wrong), by checking
            // the first value has a price value.
            var p = pricing[0].price();
            if (p === null || typeof(p) === 'undefined') return;
            this.price(pricing.reduce(function(prev, cur) {
                return prev + cur.price();
            }, 0));
        }
    }, appointment)
    .extend({ rateLimit: { method: 'notifyWhenChangesStop', timeout: 20 } });

    return appointment;
};

function pricingSummaryDetailView(pricingSummaryDetail, jobTitleID, app) {
    var observable = ko.observable(app.model.serviceProfessionalServices.asModel()), // default empty object
        serviceID = pricingSummaryDetail.serviceProfessionalServiceID();

    pricingSummaryDetail.serviceProfessionalService = observable;

    app.model.serviceProfessionalServices.getItem(jobTitleID, serviceID).then(function(service) {
        var serviceModel = app.model.serviceProfessionalServices.asModel(service);
        observable(serviceModel);
    });

    return pricingSummaryDetail;
}
