({
    getTemplateBody : function(component, event, helper) {
        var recordId = component.get("v.recordId");
	    // var action = component.get("c.getInvoiceLines");
	    // action.setParams({
	    //     recordId : recordId
	    // });
	    // action.setCallback(this, function(response){
	    //     var state = response.getState();
	    //     if(state === "SUCCESS"){
	    //         var result =  response.getReturnValue();
	    //         component.set("v.invoiceLines", result);
	    //     }
	    // });
	    // $A.enqueueAction(action);

		var action = component.get("c.createInvoice");
		action.setParams({
		    recordId : recordId
		});
		action.setCallback(this, function(response){
		    var state = response.getState();
		    if(state === "SUCCESS"){
		        var result =  response.getReturnValue();
		        component.set("v.invoiceLines", result);
		    }
		});
		$A.enqueueAction(action);

	},
})