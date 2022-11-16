({
    createRFQ: function (component, event, helper) {
        var cOrder = component.get('v.createRfq');
        console.log('cOrder ==> ' + cOrder.Name);
        var action = component.get("c.RFQFrom_Option");
        console.log('========');
        action.setParams({
            rfq: cOrder,
            optionId: component.get("v.recordId")
        });
        console.log('========');
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('State--------->'+response.getState());
            console.log(state);
            console.log('State => ' + state);
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                helper.showToast("Success", "Success", "New RFQ is created.", "5000");
                $A.get("e.force:closeQuickAction").fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": result,
                    "slideDevName": "Detail"
                });
                navEvt.fire();
            } else {
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
                var error = response.getError();
                console.log('Error =>', { error });
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);

    },
    closeModal: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})