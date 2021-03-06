/**
    Collection of public information from a user,
    holded on different models
    
    TODO: Some fields introduced to help the ServiceProfessionalInfo component, but may require refactor
**/
'use strict';

var Model = require('./Model'),
    PublicUserProfile = require('./PublicUserProfile'),
    PublicUserRating = require('./PublicUserRating'),
    PublicUserVerificationsSummary = require('./PublicUserVerificationsSummary'),
    PublicUserJobTitle = require('./PublicUserJobTitle'),
    PublicUserStats = require('./PublicUserStats'),
    UserEducation = require('./UserEducation'),
    UserVerification = require('./UserVerification'),
    ko = require('knockout');

function PublicUser(values) {
    
    Model(this);
    
    this.model.defProperties({
        profile: { Model: PublicUserProfile },
        rating: { Model: PublicUserRating },
        verificationsSummary: { Model: PublicUserVerificationsSummary },
        jobProfile: {
            Model: PublicUserJobTitle,
            isArray: true
        },
        stats: { Model: PublicUserStats },
        education: {
            Model: UserEducation,
            isArray: true
        },
        verifications: {
            Model: UserVerification,
            isArray: true
        },
        // TODO To implement on server, REST API
        backgroundCheckPassed: null, // null, true, false
        // Utility data for ServiceProfessionalInfo; used to at /profile
        selectedJobTitleID: null,
        isClientFavorite: false
    }, values);
    
    // Utilities for ServiceProfessionalInfo; used to at /profile
    this.selectedJobTitle = ko.pureComputed(function() {
        var jid = this.selectedJobTitleID(),
            jp = this.jobProfile();
        if (!jid || !jp) return null;
        var found = null;
        jp.some(function(jobTitle) {
            if (jobTitle.jobTitleID() === jid) {
                found = jobTitle;
                return true;
            }
        });
        return found;
    }, this);
    
    this.backgroundCheckLabel = ko.pureComputed(function() {
        var v = this.backgroundCheckPassed();
        if (v === true) return 'OK';
        else if (v === false) return 'FAILED';
        else return '';
    }, this);
    
    // Utilities for /profile
    /**
        Get an array of the non-selected job titles.
    **/
    this.otherJobTitles = ko.pureComputed(function() {
        var jid = this.selectedJobTitleID();
        var jp = this.jobProfile();
        return jp.filter(function(jt) {
            return jt.jobTitleID() !== jid;
        });
    }, this);
    this.otherJobTitleNames = ko.pureComputed(function() {
        return this.otherJobTitles().map(function(jd) {
            return jd.jobTitleSingularName();
        }).join(', ');
    }, this);
}

module.exports = PublicUser;
