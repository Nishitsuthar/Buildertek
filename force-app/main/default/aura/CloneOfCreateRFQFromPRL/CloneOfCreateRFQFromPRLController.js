({
    doInit : function(component, event, helper) {
        var action = component.get("c.getPRLD");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS' && response.getReturnValue()) {
                var result =  response.getReturnValue();
                console.log( response.getReturnValue())
                if(result.length > 0){
                    component.set("v.openBox",true)
                    component.set("v.PaginationList",response.getReturnValue());
                    var y = [];
                    for(let i=0;i<result.length;i++){
                        if(result[i].VendorName != undefined && result[i].VendorName != null){
                            if(result[i].VendorName != null && result[i].VendorName != undefined){
                                y.push((result[i].VendorName));
                            }
                        }
                    }
                    var uniqueArray = [];
                    for(let i=0; i < y.length; i++){
                        if(uniqueArray.indexOf(y[i]) === -1) {
                            uniqueArray.push(y[i]);
                        }
                    }
                    component.set("v.vendorList",uniqueArray);
                    console.log(y);
                }
                else{
                    var action2 = component.get("c.getPRLDsCheck");
                    action2.setParams({
                        recordId: component.get("v.recordId")
                    });
                     action2.setCallback(this, function (response) {
                         var result2 = response.getReturnValue();
                         if(result2.length > 0){
                                                 component.set("v.openBox",false)
                                                  $A.get("e.force:closeQuickAction").fire();
                            // alert("ok")
                             var toastEvent = $A.get("e.force:showToast");
                             toastEvent.setParams({
                                 title : 'Error',
                                 message:"All the PRLDs are associated with respective RFQs.",
                                 duration:' 5000',
                                 key: 'info_alt',
                                 type: 'error',
                                 mode: 'pester'
                             });
                             toastEvent.fire();
                               
                         }
                         else{
                              component.set("v.openBox",false)
                                                  $A.get("e.force:closeQuickAction").fire();
                             var toastEvent = $A.get("e.force:showToast");
                             toastEvent.setParams({
                                 title : 'Error',
                                 message:"There are no PRLD's",
                                 duration:' 5000',
                                 key: 'info_alt',
                                 type: 'error',
                                 mode: 'pester'
                             });
                             toastEvent.fire();
                         }
                         
                     });
                     $A.enqueueAction(action2);
                 /*   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:"All the PRLD's are associated with respective RFQ's.",
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire(); */
                 
                    
                }
            }
            else{
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    closeModel :  function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    selectAll : function(component, event, helper) { 
        debugger;
        var selectedHeaderCheck = event.getSource().get("v.value"); 
        var Submittals = component.get("v.PaginationList");
        var getAllId = component.find("checkContractor");
        if (getAllId != undefined) {
            if (Submittals.length > 1) {
                if(! Array.isArray(getAllId)){
                    if(selectedHeaderCheck == true){ 
                        component.find("checkContractor").set("v.value", true); 
                        component.set("v.selectedCount", 1);
                    }else{
                        component.find("checkContractor").set("v.value", false);
                        component.set("v.selectedCount", 0);
                    }
                }
                else{ 
                    if (selectedHeaderCheck == true) {
                        for (var i = 0; i < getAllId.length; i++) {
                            component.find("checkContractor")[i].set("v.value", true);
                            console.log( component.find("checkContractor")[i].get("v.value"))
                            var checkbox = component.find("checkContractor")[i].get("v.text");  
                            Submittals[i].isCheck = true;
                        }
                    } 
                    else{
                        for (var i = 0; i < getAllId.length; i++) {
                            component.find("checkContractor")[i].set("v.value", false); 
                            var checkbox = component.find("checkContractor")[i].get("v.text"); 
                            var Submittals = component.get("v.PaginationList");
                            Submittals[i].isCheck = false;
                        }
                    } 
                } 
            }else{
                var i = 0;
                if (selectedHeaderCheck == true) {
                    component.find("checkContractor").set("v.value", true); 
                    component.set("v.selectedCount", 1);
                    Submittals[i].isCheck = true;
                } else {
                    component.find("checkContractor").set("v.value", false);
                    component.set("v.selectedCount", 0);
                    Submittals[i].isCheck = false;
                }
            }   
        }
        
        component.set("v.PaginationList",Submittals);
    },
    
    handleCheck : function(component, event, helper) {
        debugger;
        var checkbox = event.getSource();
        var Submittals = component.get("v.PaginationList");
        for(var i=0 ; i < Submittals.length;i++){
            if(Submittals[i] != null){
                if(Submittals[i].Id == checkbox.get("v.text") && Submittals[i].isCheck == false){
                    Submittals[i].isCheck = true;
                }
                else if(Submittals[i].Id == checkbox.get("v.text") && Submittals[i].isCheck == true){
                    Submittals[i].isCheck = false;
                }    
            }else if(Submittals[i] != null){
                if(Submittals[i].Id == checkbox.get("v.text") && Submittals[i].isCheck == false){
                    Submittals[i].isCheck = true;
                }
                else if(Submittals[i].Id == checkbox.get("v.text") && Submittals[i].isCheck == true){
                    Submittals[i].isCheck = false;
                }    
            }  
        }
    },
    
    importBudget : function(component, event, helper){
        component.set("v.Spinner", true);
        var record  = component.get("v.recordId");
        var select = component.get("v.selectedobjInfo");
        var budgetsList = component.get("v.PaginationList");
        var budgetIds = [];
        if(budgetsList != null){
            for(var i=0 ; i < budgetsList.length;i++){
                if(budgetsList[i].isCheck == true){
                    budgetIds.push(budgetsList[i].Id);
                }
            }
        }
        if(budgetIds.length > 0){
            component.set("v.selectedobjInfo",budgetIds);
            // alert(JSON.stringify(budgetIds));
            var action = component.get("c.insertRFQ");
            action.setParams({
                recordId: component.get("v.recordId"),
                Ids:budgetIds
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    component.set("v.isdisabled",true);
                    $A.get("e.force:closeQuickAction").fire();
                    var result = response.getReturnValue();
                    if(result != null && result != 'null'){
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": result,
                            "slideDevName": "related"
                        });
                        navEvt.fire();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: 'RFQ is created successfully.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
                else{
                    component.set("v.isdisabled",true);
                    component.set("v.Spinner", false);
                    $A.get("e.force:closeQuickAction").fire();
                    var error = response.getError();
                    console.log(error)
                    var errorMessage = error[0].fieldErrors.Name[0].message
                    console.log(errorMessage);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: errorMessage,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.Spinner", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please Select at least One PRLD record.',
                "type": 'Error',
                "duration": '10000',
                "mode": 'dismissible'
            });    
            toastEvent.fire();
        }
    },
    
    
})