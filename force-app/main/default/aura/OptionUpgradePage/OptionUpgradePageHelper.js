({
    initHelper: function(component, event, helper){
        // For Set Tab Name
        component.set("v.Spinner", true);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then((response) => {
            let opendTab = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: opendTab,
                label: "Upgrade"
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
            pageNumber : component.get("v.pageNumber"),
            pageSize : 10,
            searchNameValue : '',
            searchTypeValue : '',
            searchManufacturerValue : '',
            searchFamilyValue : ''
        });
        action.setCallback(this, function (response) {
            component.set("v.Spinner", false);
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('Result => ',{result});
                component.set("v.optionWrapper", result);
                if (result.productCount > 10) {
                    var totalPage = Math.trunc(result.productCount/10)+1;
                    component.set("v.totalPage", totalPage);
                } else{
                    component.set("v.totalPage", 1);
                }
                component.set("v.optionValue", result.option);

                if (result.productWrapperList.length == 0) {
                    component.set("v.nullProduct", true);
                } else{
                    component.set("v.productWrapper", result.productWrapperList);
                }
            } else{
                var error = response.getError();
                console.log('Error => ', {error});
                helper.showToast("Error", "Error", "Something Went Wrong, Please Refresh Page", "5000");
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
            pageNumber : component.get("v.pageNumber"),
            pageSize : 10,
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
                component.set("v.productWrapper", result.productWrapperList);
                if (searchNameValue == '' && searchTypeValue == '' && searchManufacturerValue == '' && searchFamilyValue == '') {
                    component.set("v.disableBtn", false);
                } else{
                    component.set("v.disableBtn", true);
                }
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