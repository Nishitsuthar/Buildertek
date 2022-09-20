({
    init: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('recordId =>',{recordId});
        var action = component.get("c.createSalesOrder");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('Status =>', {state});
            var result = response.getReturnValue();
            console.log('Result =>', {result});
        });
        $A.enqueueAction(action);
    },
})