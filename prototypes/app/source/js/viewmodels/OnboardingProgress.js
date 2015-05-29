/** OnboardingProgress view model.
    It tracks the onboarding information and methods
    to update views to that state
**/
var Model = require('../models/Model'),
    ko = require('knockout');

function OnboardingProgress(values) {

    Model(this);
    
    this.model.defProperties({
        group: '',
        stepNumber: -1,
        steps: []
    }, values);
    
    this.totalSteps = ko.pureComputed(function() {
        return this.steps().length;
    }, this);
    
    this.stepName = ko.pureComputed(function() {
        var num = this.stepNumber(),
            tot = this.totalSteps();

        if (tot > 0 &&
            num > -1 &&
            num < tot) {
            var name = this.steps()[num] || '';
            return name;
        }
        else {
            return null;
        }
    }, this);
    
    this.stepUrl = ko.pureComputed(function() {
        var url = this.stepName();
        if (url && !/^\//.test(url))
            url = '/' + url;
        return url;
    }, this);

    this.stepReference = ko.pureComputed(function() {
        return this.group() + ':' + this.stepUrl();
    }, this);
    
    this.progressText = ko.pureComputed(function() {
        // TODO L18N
        return this.stepNumber() + ' of ' + this.totalSteps();
    }, this);
    
    this.inProgress = ko.pureComputed(function() {
        return !!this.stepUrl();
    }, this);
}

module.exports = OnboardingProgress;

OnboardingProgress.prototype.setStepByName = function setStepByName(name) {
    var stepIndex = this.steps().indexOf(name);
    if (stepIndex > -1) {
        this.stepNumber(stepIndex);
        return true;
    }
    return false;
};

/**
    Static list of all the steps groups for the app
**/
OnboardingProgress.predefinedStepGroups = {
    // Scheduling onboarding, aka welcome
    welcome: [
        'welcome',
        'addJobTitles',
        'freelancerPricing',
        'serviceAddresses',
        'weeklySchedule',
        'contactInfo'
    ],
    marketplace: [
    ],
    payment: [
    ]
};
