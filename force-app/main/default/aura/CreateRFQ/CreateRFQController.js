({
	createRFQ : function(component, event, helper) {
		component.set("v.Spinner", true);
            var changeOrderFields = component.get('v.createRfq');
            var action = component.get("c.createRfq");
            action.setParams({
                cOrder: changeOrderFields,
                optionId: component.get("v.recordId")
            });
	},
	closePopup: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})