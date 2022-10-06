({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('recordId => '+recordId);
        var action = component.get("c.getDetails");
        action.setParams({
	        recordId : recordId
	    });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
        });
        $A.enqueueAction(action);   
    }
})