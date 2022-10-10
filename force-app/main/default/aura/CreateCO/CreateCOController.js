({
    doInit: function(component, event, helper) {
        component.set('v.optionId', component.get("v.recordId"));
    },
    createRecord: function(component, event, helper) {
        try {
            var changeOrderFields = component.get('v.changeOrder');

            var action = component.get("c.changeOrderList");
            action.setParams({
                "cOrder": changeOrderFields,
                "optionId": component.get('v.optionId')
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log({ state });
                var result = response.getReturnValue();
                console.log({ result });
            });

            // $A.get("e.force:closeQuickAction").fire();
            $A.enqueueAction(action);

            console.log(component.get('v.purchaseOrder') + '----------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>');


        } catch (e) {
            console.log({ e });
        }

    },
    closePopup: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();

    }


});