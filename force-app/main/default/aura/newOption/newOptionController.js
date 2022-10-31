({
	createRecord : function(component, event, helper) {
		component.set("v.Spinner", true);
		var Option = component.get('v.Option');

		console.log('Option ::', JSON.stringify(Option));

		var action = component.get("c.createoption");
		action.setParams({ 
			"option": Option
		});		
		action.setCallback(this, function(a) {
			var state = a.getState();
			 if (state === "SUCCESS") {
				 var name = a.getReturnValue();
				 console.log(name);
				 var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "Success",
					"title": "Success!",
					"message": "The record has been created successfully."
				});
				toastEvent.fire();
				 var navEvent = $A.get("e.force:navigateToSObject");
                    navEvent.setParams({
                        "recordId": name,
                    });
                    navEvent.fire();
			 }
		  else
		  {
			var error= a.getError();
			console.log('error ==> ',{error});
			   alert("Failed");
		  }
		 });
	 $A.enqueueAction(action)
	},
    closePopup: function(component, event, helper) {

		$A.get('e.force:refreshView').fire();
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/o/buildertek__Question__c/list?filterName=Recent"
        });
        urlEvent.fire();


        $A.get("e.force:closeQuickAction").fire();
        window.setTimeout(
            $A.getCallback(function () {
                $A.get('e.force:refreshView').fire();
            }), 1000
        );



        // $A.get("e.force:closeQuickAction").fire();
    }, 

	changeProduct: function(component, event, helper){
		var Option = component.get('v.Option');
		var productId = Option.buildertek__Product__c;
		console.log('product ==> '+productId);

		productId = productId.toString();
		console.log(typeof productId);

		if (productId != '') {
			var action = component.get("c.getProduct");

			action.setParams({ 
				"productId": productId
			});		
			action.setCallback(this, function(response) {
				var state = response.getState();
				console.log('Status => '+state);
				var result = response.getReturnValue();
				console.log('result => ',{result});

				Option.Name = result.Name;
				Option.buildertek__Manufacturer__c = result.buildertek__Manufacturer__c;

				console.log('Option ==> ', {Option});
				component.set("v.Option", Option);

			});
			$A.enqueueAction(action);
		}


		
	},

	onSelectedChanged: function(component, event, helper){
		var checkValue = component.find('selectCheck').get("v.checked");
		var Option = component.get('v.Option');
		Option.buildertek__Selected__c = checkValue;
		component.set("v.Option", Option);
	}, 

	onOptionChanged: function(component, event, helper){
		var checkValue = component.find('optionCheck').get("v.checked");
		var Option = component.get('v.Option');
		Option.buildertek__Default_Option__c = checkValue;
		component.set("v.Option", Option);
	}, 

	onUpgradeChanged: function(component, event, helper){
		var checkValue = component.find('upgradeCheck').get("v.checked");
		var Option = component.get('v.Option');
		Option.buildertek__Upgrade__c = checkValue;
		component.set("v.Option", Option);
	}, 

})