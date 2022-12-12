({
    /*
    Description:- This method used for get and display all the fields of the meeting object record in modal box
    Created Date:- 30th November
    
    */
    doInit: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            var action = component.get("c.getMeetingData");
            action.setParams({
                recordId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(response);
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue());

                    var resule = response.getReturnValue();
                    var duration = resule.meet.buildertek__Start_Time__c;
                    var minutes = Math.floor((duration / (1000 * 60)) % 60);
                    var hours = Math.floor((duration / (1000 * 60 * 60)) % 24);
                    
                    hours = (hours < 10) ? "0" + hours : hours;
                    minutes = (minutes < 10) ? "0" + minutes : minutes;
                    var dateData = hours + ":" + minutes;
                    resule.meet.buildertek__Start_Time__c = dateData;
                    console.log('Start time',dateData);

                    
                    var duration1 = resule.meet.buildertek__End_Time__c;
                    var minutes = Math.floor((duration1 / (1000 * 60)) % 60);
                    var hours = Math.floor((duration1 / (1000 * 60 * 60)) % 24);

                    hours = (hours < 10) ? "0" + hours : hours;
                    minutes = (minutes < 10) ? "0" + minutes : minutes;
                    var dateData1 = hours + ":" + minutes;
                    resule.meet.buildertek__End_Time__c = dateData1;
                    console.log('End time',dateData1);

                    component.set('v.oldMeeting', resule.meet);
                    component.set('v.Atendee', response.getReturnValue().Attendee);
                    component.set('v.actionItemRec', response.getReturnValue().actionItem);

                }
            });
            $A.enqueueAction(action);

            helper.getPicklist(component, event, helper);
            component.set("v.Spinner", false);
        } catch (e) {
            console.log({ e });
        }
    },

    /*
    Description:- This method used for close the pop up box when user click on cancel!
    Created Date:- 30th November
    
    */
    Cancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();

    },

    /*
    Description:- This method used for Clone meeting object record and its related list (Atendee and ActionItem)
    Created Date:- 30th November
    
    */
    Save: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            var cloneMeetRecord = component.get('v.oldMeeting');
            delete cloneMeetRecord['Id'];

            var action = component.get("c.save");
            action.setParams({
                meet: cloneMeetRecord,
                attendee: component.get('v.Atendee'),
                action: component.get('v.actionItemRec')
            });
            action.setCallback(this, function(response) {
                console.log('Response----->',response);
                var state = response.getState();
                var result = response.getReturnValue();                
                if (state === "SUCCESS") {        
                    console.log('save action');               
                    component.set("v.Spinner", false);
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Meeting added successfully",
                        "type": "success",
                        "duration": 5000
                    });
                    toastEvent.fire();


                    console.log(response.getReturnValue());
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result,
                        "slideDevName": "related"
                    });
                    navEvt.fire();


                } else {
                    component.set("v.Spinner", false);
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Failed to save record",
                        "type": "error",
                        "duration": 5000
                    });
                    toastEvent.fire();


                }
            });



            $A.enqueueAction(action);


        } catch (e) {
            console.log({ e });
        }

    },


})