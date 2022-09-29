({
    createPO: function(component, event, helper){
        var recordId = component.get("v.recordId");
        console.log('recordId => '+recordId);
    },

    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})