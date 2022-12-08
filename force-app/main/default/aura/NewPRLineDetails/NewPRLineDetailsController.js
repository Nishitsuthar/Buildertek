({
    doInit: function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        component.set("v.recordId", addressableContext.attributes.recordId);
        component.set("v.PRLineDetails.buildertek__Pricing_Request_Line__c", addressableContext.attributes.recordId);

    },

    closePopup: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            if (response == true) {
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({
                        tabId: focusedTabId
                    });

                    var recordId = component.get("v.recordId");
                    if (recordId) {
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": recordId,
                            "slideDevName": "detail"
                        });
                        navEvt.fire();
                    } else {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/lightning/o/buildertek__Pricing_Request_Line_Details__c/list?filterName=Recent"
                        });
                        urlEvent.fire();


                        $A.get("e.force:closeQuickAction").fire();
                        window.setTimeout(
                            $A.getCallback(function() {
                                $A.get('e.force:refreshView').fire();
                            }), 1000
                        );
                    }

                })
                .catch(function(error) {
                    console.log(error);
                });
            } else {
                var recordId = component.get("v.recordId");
                if (recordId) {
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": recordId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/o/buildertek__Pricing_Request_Line_Details__c/list?filterName=Recent"
                    });
                    urlEvent.fire();


                    $A.get("e.force:closeQuickAction").fire();
                    window.setTimeout(
                        $A.getCallback(function() {
                            $A.get('e.force:refreshView').fire();
                        }), 1000
                    );
                }

            }

        });

    },

    createRecord: function(component, event, helper) {
        component.set("v.Spinner", true);
        var PRLineDetails = component.get('v.PRLineDetails');

        console.log('PRLineDetails ::', JSON.stringify(PRLineDetails));

        if (PRLineDetails.buildertek__Pricing_Request_Line__c == null || PRLineDetails.buildertek__Pricing_Request_Line__c == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error!",
                "message": "Please First Add Pricing Request Line."
            });
            toastEvent.fire();
        } else{
            var action = component.get("c.createPRLineDetails");
            action.setParams({
                "PRLineDetails": PRLineDetails
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {

                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.closeTab({
                                tabId: focusedTabId
                            });
                        })
                        .catch(function(error) {
                            console.log(error);
                        });

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
                } else {
                    var error = a.getError();
                    console.log('error ==> ', { error });
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Something Went Wrong"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }

    },
})