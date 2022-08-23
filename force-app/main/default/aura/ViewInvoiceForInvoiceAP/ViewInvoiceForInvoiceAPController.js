({
    init: function (component, event, helper) {
        component.set("v.Spinner", true);
        var dbAction = component.get("c.getTemplates");
        dbAction.setParams({
            recordId: component.get("v.recordId")
        });
        dbAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.templates", response.getReturnValue());
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(dbAction);
    },
    
    preiewEmailTemplate: function (component, event, helper) {
        debugger;
        var selectedTemplate = component.get("v.selectedTemplate");
        if (selectedTemplate != undefined) {
            component.set("v.isTemplateSelected", true);
            var recordId = component.get("v.recordId");
            var action = component.get("c.getInvoiceLines");
            action.setParams({
                recordId : recordId,
                templateId : component.get("v.selectedTemplate")
            });
            action.setCallback(this, function(response){
                //  apex/BT_Invoice
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result =  response.getReturnValue();
                    component.set("v.invoiceLines", result);
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/apex/BT_Invoice?id='+component.get("v.recordId")+'&TempId='+ component.get("v.selectedTemplate")
                    });
                    urlEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    closeModel: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})