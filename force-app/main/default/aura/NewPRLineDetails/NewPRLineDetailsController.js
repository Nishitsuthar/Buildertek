({
    doInit: function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        component.set("v.recordId", addressableContext.attributes.recordId);
        component.set("v.PRLineDetails.buildertek__Pricing_Request_Line__c", addressableContext.attributes.recordId);

    },

    closePopup: function(component, event, helper) {
        helper.closePopupHelper(component, event, helper);
    },

    createRecord: function(component, event, helper) {
        helper.createRecordHelper(component, event, helper);
    },

    changePriceBook: function(component, event, helper) {
        helper.changePriceBookHelper(component, event, helper);
    }
})