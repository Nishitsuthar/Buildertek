({
    initHelper: function(component, event, helper){
        // For Set Tab Name
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then((response) => {
            let opendTab = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: opendTab,
                label: "Update Option"
            });
            workspaceAPI.setTabIcon({
                tabId: opendTab,
                icon: 'custom:custom24',
                iconAlt: 'Update Option'
            });
        });

        var action = component.get("c.getDetails");
        action.setParams({
            recordId : component.get("v.recordId"),
            searchNameValue : '',
            searchTypeValue : '',
            searchManufacturerValue : '',
            searchFamilyValue : ''
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('Result => ',{result});
                component.set("v.productList", result);
                // helper.showToast("Success", "Success", "", "5000");
            } else{
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
            }
        });
        $A.enqueueAction(action);   
    },
    
    searchHelper: function(component, event, helper){
        var searchNameValue = component.get("v.searchNameFilter");
        var searchTypeValue = component.get("v.searchTypeFilter");
        var searchManufacturerValue = component.get("v.searchManufacturerFilter");
        var searchFamilyValue = component.get("v.searchFamilyFilter");

        var action = component.get("c.getDetails");

        console.log(component.get("v.recordId"));
        action.setParams({
	        recordId : component.get("v.recordId"),
            searchNameValue : searchNameValue,
            searchTypeValue : searchTypeValue,
            searchManufacturerValue : searchManufacturerValue,
            searchFamilyValue : searchFamilyValue
	    });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('Result => ',{result});
                component.set("v.productList", result);
            } else{
                helper.showToast("Error", "Error", "Something Went Wrong", "5000");
            }
        });
        $A.enqueueAction(action); 

    },

    showToast: function(type, title, message, time) {
        try {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "type": type,
                "message": message,
                "duration": time
            });
            toastEvent.fire();
        } catch (error) {
            console.log({ error });
        }
    },
})