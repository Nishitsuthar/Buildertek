({    
    invoke : function(component, event, helper) {
        var record = component.get("v.recordId");
        
        var redirect = $A.get("e.force:navigateToSObject");
        
        redirect.setParams({
        "recordId": record
        });
            
        redirect.fire();

        var toastEvent = $A.get("e.force:showToast");
            
        toastEvent.setParams({
            title : 'Success',
            message: 'New Takeoff Successfully Cloned',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        
        toastEvent.fire();
    }
})