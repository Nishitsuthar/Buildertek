({
    createOrder: function (component, event, helper) {
        component.set("v.Spinner", true);
        var recordId = component.get("v.recordId");
        console.log('recordId =>',{recordId});
        var action = component.get("c.createSalesOrder");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function (response) {
            var result = response.getReturnValue();
            console.log('Result =>', {result});
            if (result == 'Success') {
                helper.showToast("Success", "Success", "New Sales Order Created.", "5000");
            } else{
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
            }
            component.set("v.Spinner", false);
	        $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },

    closeModal : function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
	}
})