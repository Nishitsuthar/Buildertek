({
    createRecord: function (component, event, helper) {
        try {
            component.set("v.Spinner", true);
            console.log('in controller ::');
            var changeOrderFields = component.get("v.changeOrder");

            var action = component.get("c.changeOptionList");
            action.setParams({
                cOrder: changeOrderFields,
                selectionTypeId: component.get("v.recordId"),
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log({ state });
                var result = response.getReturnValue();
                console.log({ result });
                if (result == "Error") {
                    helper.showToast("Error", "Error", "Upgraded Option Not found", "5000");
                } else {
                    helper.showToast("Success", "Success", "Your Change Order is created", "5000");
                    var navEvent = $A.get("e.force:navigateToSObject");
                    navEvent.setParams({
                        recordId: result,
                    });
                    navEvent.fire();
                }
                component.set("v.Spinner", false);
                $A.get("e.force:closeQuickAction").fire();
            });

            // $A.get("e.force:closeQuickAction").fire();
            $A.enqueueAction(action);
        } catch (e) {
            console.log({ e });
        }
    },
    closePopup: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
});