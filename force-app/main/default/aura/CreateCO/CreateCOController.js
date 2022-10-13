({
    doInit: function(component, event, helper) {
        component.set('v.optionId', component.get("v.recordId"));
    },
    createRecord: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            var changeOrderFields = component.get('v.changeOrder');

            var action = component.get("c.changeOrderList");
            action.setParams({
                cOrder: changeOrderFields,
                optionId: component.get('v.optionId')
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log({ state });
                var result = response.getReturnValue();
                console.log({ result });
                if(result=='Error'){
                    tst.setParams({
                        title: 'Error',
                        message: 'Something Went Wrong',
                        type: 'Error',
                        duration: 3000
                    });
                    tst.fire();
                }else {
                    var tst = $A.get("e.force:showToast");
                    tst.setParams({
                        title: 'Complete',
                        message: 'Your Change Order is created',
                        type: 'success',
                        duration: 5000
                    });
                    tst.fire();
                    var navEvent = $A.get("e.force:navigateToSObject");
                    navEvent.setParams({
                        "recordId": result,
                    });
    
                    navEvent.fire();
                }
                component.set("v.Spinner", false);
                $A.get("e.force:closeQuickAction").fire();
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