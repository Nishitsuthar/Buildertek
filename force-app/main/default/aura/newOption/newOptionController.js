({
	createRecord : function(component, event, helper) {
		
		var Option = component.get('v.Option');

		console.log('Option ::', JSON.stringify(Option));
	},
    closePopup: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})