({
    createPO: function(component, event, helper){
        var recordId = component.get("v.recordId");
        console.log('recordId => '+recordId);
        var action = component.get("c.createPO");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log('Result =>', { result });
            if (result != 'Error') {
                helper.showToast("Success", "Success", "New PO Line Created.", "5000");
                var navEvent = $A.get("e.force:navigateToSObject");
                navEvent.setParams({
                    "recordId": result,
                });
                navEvent.fire();
            } else {
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
            }

            component.set("v.Spinner", false);
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },

    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})