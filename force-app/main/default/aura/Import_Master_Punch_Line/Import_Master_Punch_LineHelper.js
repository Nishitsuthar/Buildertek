({
    doInit: function (component, event, helper) {
        try {
            component.set("v.Spinner", true);
            var action = component.get("c.getMasterPL");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var pageSize = component.get("v.pageSize");
                    var result = response.getReturnValue();
                    console.log('MaterPL From Apex =>', { result });
                    component.set("v.masterPunchList", result);
                    component.set("v.totalRecords", component.get("v.masterPunchList").length);
                    component.set("v.startPage", 0);
                    component.set("v.endPage", pageSize - 1);

                    var PaginationList = [];
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get("v.masterPunchList").length > i)
                            PaginationList.push(result[i]);
                    }

                    component.set('v.PaginationList', PaginationList);
                    console.log({ PaginationList });
                    component.set("v.Spinner", false);
                }
            });
            $A.enqueueAction(action);
        } catch (error) {
            component.set("v.Spinner", false);
            console.log("error in helper doInit Method ==>");
            console.log({ error });
        }
    },

    closeModel: function (component, event, helper) {
        try {
            $A.get("e.force:closeQuickAction").fire();
        } catch (error) {
            console.log("error in Helper closeModel Method");
            console.log({ error });
        }
    },

    previous: function (component, event, helper) {
        try {
            var sObjectList = component.get("v.masterPunchList");
            var end = component.get("v.endPage");
            var start = component.get("v.startPage");
            var pageSize = component.get("v.pageSize");
            var Paginationlist = [];
            var counter = 0;
            for (var i = start - pageSize; i < start; i++) {
                if (i > -1) {
                    Paginationlist.push(sObjectList[i]);
                    counter++;
                } else {
                    start++;
                }
            }
            start = start - counter;
            end = end - counter;
            component.set("v.startPage", start);
            component.set("v.endPage", end);
            component.set('v.PaginationList', Paginationlist);
        } catch (error) {
            console.log("error in Helper previous Method");
            console.log({ error });
        }
    },

    next: function (component, event, helper) {
        try {
            var sObjectList = component.get("v.masterPunchList");
            var end = component.get("v.endPage");
            var start = component.get("v.startPage");
            var pageSize = component.get("v.pageSize");
            var Paginationlist = [];
            var counter = 0;
            for (var i = end + 1; i < end + pageSize + 1; i++) {
                if (sObjectList.length > i) {
                    Paginationlist.push(sObjectList[i]);
                }
                counter++;
            }
            start = start + counter;
            end = end + counter;
            component.set("v.startPage", start);
            component.set("v.endPage", end);
            component.set('v.PaginationList', Paginationlist);
        } catch (error) {
            console.log("error in Helper next Method");
            console.log({ error });
        }
    },

    selectAll: function (component, event, helper) {
        try {
            // var selectedHeaderCheck = event.getSource().get("v.value");
            // var Submittals = component.get("v.masterPunchList");
            // var getAllId = component.find("checkContractor");
            // if (Submittals != null) {
            //     if (Submittals.length > 1) {
            //         if (!Array.isArray(getAllId)) {
            //             if (selectedHeaderCheck == true) {
            //                 component.find("checkContractor").set("v.value", true);
            //             } else {
            //                 component.find("checkContractor").set("v.value", false);
            //             }
            //         }
            //         else {
            //             if (selectedHeaderCheck == true) {
            //                 for (var i = 0; i < getAllId.length; i++) {
            //                     component.find("checkContractor")[i].set("v.value", true);
            //                     var checkbox = component.find("checkContractor")[i].get("v.text");
            //                     Submittals[i].quoteCheck = true;
            //                 }
            //             }
            //             else {
            //                 for (var i = 0; i < getAllId.length; i++) {
            //                     component.find("checkContractor")[i].set("v.value", false);
            //                     var checkbox = component.find("checkContractor")[i].get("v.text");
            //                     var Submittals = component.get("v.masterPunchList");
            //                     Submittals[i].quoteCheck = false;
            //                 }
            //             }
            //         }
            //     }
            //     else {
            //         var i = 0;
            //         if (selectedHeaderCheck == true) {
            //             component.find("checkContractor").set("v.value", true);
            //             var checkbox = component.find("checkContractor").get("v.text");
            //             Submittals[i].quoteCheck = true;
            //         }
            //         else {
            //             component.find("checkContractor").set("v.value", false);
            //             var checkbox = component.find("checkContractor").get("v.text");
            //             var Submittals = component.get("v.masterPunchList");
            //             Submittals[i].quoteCheck = false;
            //         }
            //     }
            // }
        } catch (error) {
            console.log("error in Helper selectAll Method");
            console.log({ error });
        }
    },

    handleCheck: function (component, event, helper) {
        try {
            var checkboxValue = event.getSource().get("v.value");
            console.log("checkbox value ==>" + checkboxValue);
            var checkboxId = event.getSource().get("v.text");
            console.log("checkbox Id ==>" + checkboxId);

        } catch (error) {
            console.log("error in Helper handleCheck Method");
            console.log({ error });
        }
    },

    importMasterPL: function (component, event, helper) {
        try {

            // component.set("v.Spinner", true);
            // var punchList = component.get("v.masterPunchList");
            // var quoteIds = [];
            // var punchListIds = [];
            // for(var i=0 ; i < punchList.length;i++){
            //     if(punchList[i].quoteCheck == true){
            //         if(punchList[i].masterQuoteRecord != null){
            //             punchListIds.push(punchList[i].masterQuoteRecord.Id);    
            //         }else if(punchList[i].quoteRecord != null){
            //             punchListIds.push(punchList[i].quoteRecord.Id);    
            //         }
            //     }
            // }


        } catch (error) {
            component.set("v.Spinner", false);
            console.log("error in Helper importMasterPL Method");
            console.log({ error });
        }
    }

})