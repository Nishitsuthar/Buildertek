({
    doInit : function(component, event, helper) {
        helper.initHelper(component, event, helper);
    }, 

    handleClick : function(component, event, helper){
        var idx = event.getSource().get("v.value");
        component.set("v.isModalOpen", true);
        var productWrapper = component.get('v.productWrapper');
        var productValue = productWrapper[idx].product;
        component.set("v.productValue", productValue);
    }, 
    
    doSearch: function (component, event, helper) {
        helper.searchHelper(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    onUpgrade: function (component, event, helper){
        component.set("v.Spinner", true);
        component.set("v.isModalOpen", false);
        var optionValue = component.get("v.optionValue");
        var productValue = component.get("v.productValue");
        var action = component.get("c.upgradeOption");
        action.setParams({
            optionValue : optionValue,
            productValue: productValue
        });
        action.setCallback(this, function (response) {
            component.set("v.Spinner", false);
            var state = response.getState();
            console.log('Status => '+state);
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                helper.showToast("Success", "Success", "Option Upgrade Sucessfully", "5000");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": result,
                    "slideDevName": "Detail"
                });
                navEvt.fire();
            } else{
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
            }
        });
        $A.enqueueAction(action);
    }, 

    onPrevious: function (component, event, helper){
        component.set("v.pageNumber", component.get("v.pageNumber")-1);
        helper.initHelper(component, event, helper);
    }, 

    onNext: function (component, event, helper){
        component.set("v.pageNumber", component.get("v.pageNumber")+1);
        helper.initHelper(component, event, helper);
    }

})