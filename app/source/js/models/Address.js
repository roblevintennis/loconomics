/** Address model **/
'use strict';

var ko = require('knockout'),
    Model = require('./Model');

function Address(values) {

    Model(this);
    
    this.model.defProperties({
        addressID: 0,
        addressName: '',
        jobTitleID: 0,
        userID: 0,
        addressLine1: null,
        addressLine2: null,
        postalCode: null,
        city: null, // Autofilled by server
        stateProvinceCode: null, // Autofilled by server
        stateProvinceName: null, // Autofilled by server
        countryCode: null, // ISO Alpha-2 code, Ex.: 'US'
        latitude: null,
        longitude: null,
        specialInstructions: null,
        isServiceArea: false,
        isServiceLocation: false,
        serviceRadius: 0,
        createdDate: null, // Autofilled by server
        updatedDate: null, // Autofilled by server
        kind: '' // Autofilled by server
    }, values);
    
    this.singleLine = ko.computed(function() {
        
        var list = [
            this.addressLine1(),
            this.city(),
            this.postalCode(),
            this.stateProvinceCode()
        ];
        
        return list.filter(function(v) { return !!v; }).join(', ');
    }, this);

    this.singleLineDetailed = ko.pureComputed(function() {
        //jshint maxcomplexity:12
        var r = this.addressLine1() || '';
        if (r) r += ' ';
        r += this.addressLine2() || '';
        if (r) r += ' - ';
        r += this.city() || '';
        if (r) r += ' ';
        if (this.stateProvinceCode()) {
            r += '(' + this.stateProvinceCode() + ') ';
        }
        r += this.postalCode() || '';
        r += (this.specialInstructions() ? ' (' + this.specialInstructions() + ')' : '');
        return r;
    }, this);
    
    this.addressLine = ko.computed(function() {
        var list = [
            this.addressLine1(),
            this.addressLine2()
        ];        
        return list.filter(function(v) { return !!v; }).join(', ');
    }, this);
    
    this.cityStateLine = ko.computed(function() {
        var list = [
            this.city(),
            this.stateProvinceCode(),
            this.postalCode()
        ];
        return list.filter(function(v) { return !!v; }).join(', ');
    }, this);    
    
    // TODO: needed? l10n? must be provided by server side?
    var countries = {
        'US': 'United States',
        'ES': 'Spain'
    };
    this.countryName = ko.computed(function() {
        return countries[this.countryCode()] || 'unknow';
    }, this);

    // Useful GPS object with the format used by Google Maps
    this.latlng = ko.computed(function() {
        return {
            lat: this.latitude(),
            lng: this.longitude()
        };
    }, this);
}

module.exports = Address;

// Public Enumeration for the 'kind' property:
Address.kind = {
    home: 'home',
    billing: 'billing',
    service: 'service'
};
