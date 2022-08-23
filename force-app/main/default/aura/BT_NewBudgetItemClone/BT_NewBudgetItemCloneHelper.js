({
    getcurr : function (component, event, helper) {
        var action = component.get("c.getcurrency");
        action.setCallback(this, function (response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                   component.set("v.currencycode",response.getReturnValue());
			} 
		});
		$A.enqueueAction(action);		
    },
    getmulticur : function (component, event, helper) {
        var action = component.get("c.getmulticurrency");
        action.setCallback(this, function (response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                  component.set("v.multicurrency",response.getReturnValue());
			} 
		});
		$A.enqueueAction(action);		
    },
    createForceRecordEditComp: function (
        component,
        event,
        helper,
        recordId,
        action,
        title,
        objAPI,
        obj
    ) {
        $A.createComponent(
            "c:BT_Force_Record_Edit", {
                "aura:id": "btNewItemEdit",
                title: title,
                objectApi: objAPI,
                parentId: component.get("v.recordId"),
                parentApi: "buildertek__Budget__c",
                newRecordName: "Budget Item",
                saveCallBack: component.get("v.refreshGridAction"),
                newRecordId: recordId,
                defaultValue: obj,
                action: action,
            },
            function (grid) {
                if (component.isValid()) {
                    var targetCmp = component.find("newItem");
                    var body = targetCmp.get("v.body");
                    body.push(grid);
                    targetCmp.set("v.body", body);
                }
            }
        );
    },
   /* helperFun : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	//$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},*/

    getBudgetLine: function (component, event, helper) {
        var action;
        action = component.get("c.getBudgetLineRecords");
        action.setParams({
            selectedBudgetId: component.get('v.expensebudget').toString()
        });
        action.setCallback(this, function (response) {
            debugger;
            if (component.isValid() && response.getState() === "SUCCESS") {
               
                var result = JSON.parse(response.getReturnValue());
                // alert( JSON.stringify(result));
                component.set('v.budgetLineItems', result);
            }
        });
        $A.enqueueAction(action);
    },

    createRFQ: function (component, event, helper) {
        var action;
        action = component.get("c.createRFQFromBudget");
        action.setParams({
            budget: component.get("v.sampleNewRecord"),
            rfq: component.get("v.newRFQ"),
            rfqItemsJson: JSON.stringify(component.get("v.newRFQItems")),
        });
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                component.find("notifLib").showNotice({
                    variant: "success",
                    header: "RFQ has been created!",
                    message: "RFQ created",
                    closeCallback: function () {},
                });
            } else {
                component.find("notifLib").showNotice({
                    variant: "error",
                    header: "Error!",
                    message: response.getError()[0].message,
                    closeCallback: function () {},
                });
            }
        });

        $A.enqueueAction(action);
    },

    addSelectedProducts: function (component, event, helper, items) {
        var action;
        action = component.get("c.createBudgetItem");
        action.setParams({
            budgetItemsJSON: JSON.stringify(items),
        });
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "",
                    message: "Product Added succesfully.",
                    type: "success",
                });
                toastEvent.fire();
                component.refreshData();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type: "error",
                    title: "Error!",
                    message: response.getError()[0].message,
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    getProductDetails: function (component, event, helper) {
       
        var productId = component.get("v.productId");
        var productName = component.get("v.productName");
        /* if(productName.length > 80){
             alert("1");
                component.set("v.Spinner", false);
                component.set("v.isDescription", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'please assign RFQ items size is lessthan 80.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                //component.get("v.onCancel")(); 
                //$A.get('e.force:refreshView').fire();
                 }else{
                component.set("v.isDescription", false); 
            }
             
             if(component.get("v.isDescription") == false){*/
                  var action = component.get("c.getProductPrice");

        action.setParams({
            productId: productId,
        });
        action.setCallback(this, function (respo) {
            var res = respo.getReturnValue();
            var getProductDetails = component.get("v.newBudgetLine");
            delete getProductDetails.buildertek__Group__r;
            ////console.log("@Budgetline@",component.get("v.recordId"));
            getProductDetails.buildertek__Budget__c = component.get("v.recordId");
            ////console.log("getprodct----",JSON.stringify(getProductDetails));
            if (res.length >= 1) {
                if (res[0].UnitPrice != null) {
                    getProductDetails.buildertek__Sales_Price__c = res[0].UnitPrice;
                }
                if (res[0].buildertek__Unit_Cost__c != null) {
                    getProductDetails.buildertek__Unit_Price__c =
                        res[0].buildertek__Unit_Cost__c;
                }

                if (res[0].buildertek__Discount__c != null) {
                    getProductDetails.buildertek__Discount__c =
                        res[0].buildertek__Discount__c;
                }
            } else {
                getProductDetails.buildertek__Unit_Cost__c = 0;
                getProductDetails.buildertek__Unit_Price__c = 0;
                getProductDetails.buildertek__Discount__c = 0;
            }
            getProductDetails.buildertek__Product__c = productId;

            getProductDetails.Name = productName;
            component.set("v.newBudgetLine", getProductDetails);

            ////console.log("getprodct----",JSON.stringify(getProductDetails));

            ////console.log("----log",res);
        });
        $A.enqueueAction(action);
             
    },

    deleteRecord: function (component, event, helper) {
        var deleteString = component.get("v.deleteRecords");
        //alert('deleteString ----------> '+JSON.stringify(deleteString));
        var action = component.get("c.deleteLineItems");
        action.setParams({
            budgetItemIds: deleteString,
        });
        action.setCallback(this, function (response) {
            component.set("v.selectedRows", []);
            component.set("v.selectedCol", []);
            $A.get("e.force:refreshView").fire();
            var grid = component.find("ItemList");
            grid.refreshData();
            component.refreshData();
        });
        $A.enqueueAction(action);
    },

    getBudgetGroups: function (component, event, helper, page) {
        $A.get("e.c:BT_SpinnerEvent").setParams({
            action: "SHOW",
        }).fire();
        var budgetIdele =  component.get("v.budgetId");
         var toggleVal = component.get("v.groupBytoggle"); 
         var toggleVal1 = component.get("v.groupBytoggle1"); 
        var toggleVal2 = component.get("v.groupBytoggle2"); 
        var bt1 = component.get("v.Isbtvalue"); 
       
        if(budgetIdele){
            
         
            if(component.find('expandCollapeseAllBtn')){
            

                if(component.find('expandCollapeseAllBtn').get('v.iconName')){
                    var budgetIdele =  component.get("v.budgetId");
                   // alert(budgetIdele);
                    var tabId = component.get("v.currentTab")
                    if(tabId){
                        var spanEle = document.getElementsByClassName(tabId+' expandAllBtn_'+budgetIdele);
                       // alert(spanEle);
                        if(spanEle[0]){
                           // alert("6");
                            spanEle[0].style.display="none";
                        }
                        if(document.getElementsByClassName(tabId+' CollapeseAllBtn_'+budgetIdele)[0]){
                           // alert("8");
                            document.getElementsByClassName(tabId+' CollapeseAllBtn_'+budgetIdele)[0].style.display="inline-block";
                        } 
                    }else{
                        var spanEle = document.getElementsByClassName(' expandAllBtn_'+budgetIdele);
                       // alert(spanEle);
                        if(spanEle[0]){
                            //alert("7");
                            spanEle[0].style.display="inline-block";
                        }
                        if(document.getElementsByClassName(' CollapeseAllBtn_'+budgetIdele)[0]){
                            document.getElementsByClassName(' CollapeseAllBtn_'+budgetIdele)[0].style.display="none";
                        }
                    }
                    
                   // console.log(spanEle[0])
                    component.find('expandCollapeseAllBtn').set("v.title", "Expand All");
                    component.find('expandCollapeseAllBtn').set("v.iconName", "utility:add");
                }
            }
        }
        
        
        
        
        if (component.get("v.recordId")) {
            // Retrieve all the section of related Ad
            var action = component.get("c.retrieveGroups");
            action.setParams({
                budgetId: component.get("v.recordId"),
                pageNumber: page,
                recordToDisply: 60,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                   console.log('result'+result);
                   //  alert('result---------->'+JSON.stringify(result));
                    if (result.formulaFields != undefined) {
                        var formulaField = JSON.parse(result.formulaFields);
                        for (var i in result.columns) {
                            for (var j in formulaField) {
                                if (j.toLowerCase() == result.columns[i].fieldName.toLowerCase()) {
                                    result.columns[i].title = formulaField[j];
                                }
                            }
                        }
                        if(toggleVal){
                             if (result.tarTable != undefined && result.tarTable.ListOfEachRecord != undefined) {
                                var records = result.tarTable.ListOfEachRecord;
                                result.groupHierarchy = groupRecords(records);
                                
                                function groupRecords(data) {
                                    var listOfRecords = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
									for(var j in data[i].recordList){
                                        if(data[i].recordList[j].fieldName == 'buildertek__Contractor__c' && data[i].recordList[j].originalValue != ''){
                                            if (!recordsMap.has(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue)) {
                                                recordsMap.set(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue, []);
                                            }
                                            recordsMap.get(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue).push(JSON.parse(JSON.stringify(data[i])));
                                        }else if(data[i].recordList[j].fieldName == 'buildertek__Contractor__c' && data[i].recordList[j].originalValue == ''){
                                            data[i].recordList[j].originalValue = 'No Vendor';
                                          
                                            if (!recordsMap.has('' + '(#&%*)' + 'No Vendor')) {
                                                recordsMap.set('' + '(#&%*)' + 'No Vendor', []);
                                            }
                                            //console.log(recordsMap.has('No vendor'),recordsMap.get("No vendor"))
                                            recordsMap.get('' + '(#&%*)' + 'No Vendor').push(JSON.parse(JSON.stringify(data[i])))
                                            //recordsMap.get('No Vendor').push(JSON.parse(JSON.stringify(data[i])));
                                        }
                                    }
									}
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        obj.groupId = result[i][0].split('(#&%*)')[0];
                                        obj.groupName = result[i][0].split('(#&%*)')[1];
                                        //ert('hi'+obj.groupName);
                                        obj.subGroupRecords = subGroupRecords(result[i][1]);
                                        listOfRecords.push(obj);
                                        
                                    }
                                   // alert('listOfRecords',listOfRecords)
                                    for(var i in listOfRecords){
                                        var obj = {}
                                             obj['unitPrice'] = 0;
                                             obj['unitPricekey'] = '';
                                             obj['orignalbudget'] = 0;
                                             obj['orignalbudgetkey'] = '';
                                             obj['TotalApprovals'] = 0;
                                             obj['TotalApprovalskey'] = '';
                                             obj['CommittedCost'] = 0;
                                        obj['CommittedCostkey'] = 0;
                                              obj['AdditionalCosts'] = 0;
                                        obj['AdditionalCostsKey'] = '';
                                         obj['InvoiceCosts'] = 0;
                                        obj['InvoiceCostsKey'] = '';
                                        obj['ProjectedCosts'] = 0;
                                        obj['ProjectedCostskey'] = '';
                                        obj['Labor1'] = 0;
                                        obj['Labor1key'] = '';
                                        obj['Forecast'] = 0;
                                        obj['Forecastskey'] = '';
                                        obj['TotalCosts'] = 0;
                                        obj['TotalCostsKey'] = '';
                                        obj['ProfitLoss'] = 0;
                                        obj['ProfitLosskey'] = '';
                                        obj['fieldType'] = '';
                                         for(var j=0;j<listOfRecords[i].subGroupRecords[0].records.length;j++){
                                             console.log(listOfRecords[i].subGroupRecords[0].records[j])
                                             var recList = listOfRecords[i].subGroupRecords[0].records[j].recordList;
                                             
                                             for(var k = 0;k<recList.length;k++){
                                                 if(recList[k].fieldType == "currency"){
                                                     if(recList[k].fieldName == "buildertek__Unit_Price__c"){
                                                         obj['unitPrice'] += recList[k].originalValue;
                                                         obj['unitPricekey'] = "buildertek__Unit_Price__c"
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Original_Budget__c"){
                                                         obj['orignalbudget'] += recList[k].originalValue;
                                                         obj['orignalbudgetkey'] = "buildertek__Original_Budget__c"
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Total_Approvals_CO__c"){
                                                         obj['TotalApprovals'] += recList[k].originalValue;
                                                         obj['TotalApprovalskey'] = 'buildertek__Total_Approvals_CO__c'
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Committed_Costs__c"){
                                                         obj['CommittedCost'] += recList[k].originalValue;
                                                         obj['CommittedCostkey'] = 'buildertek__Committed_Costs__c'
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Additional_Costs__c"){
                                                         obj['AdditionalCosts'] += recList[k].originalValue;
                                                         obj['AdditionalCostsKey'] = "buildertek__Additional_Costs__c"
                                                     }
                                                      if(recList[k].fieldName == "buildertek__Invoice_total__c"){
                                                         obj['InvoiceCosts'] += recList[k].originalValue;
                                                         obj['InvoiceCostsKey'] = "buildertek__Invoice_total__c"
                                                     }
                                                     
                                                     if(recList[k].fieldName == "buildertek__Labor1__c"){
                                                         obj['Labor1'] += recList[k].originalValue;
                                                         obj['Labor1key'] = 'buildertek__Labor1__c'
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Projected_Costs__c"){
                                                         obj['ProjectedCosts'] += recList[k].originalValue;
                                                         obj['ProjectedCostskey'] = 'buildertek__Projected_Costs__c'
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Forecast_To_Complete__c"){
                                                         obj['Forecast'] += recList[k].originalValue;
                                                         obj['Forecastskey'] = 'buildertek__Forecast_To_Complete__c'
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Total_Costs__c"){
                                                         obj['TotalCosts'] +=  recList[k].originalValue;
                                                         obj['TotalCostsKey'] = 'buildertek__Total_Costs__c'
                                                     }
                                                     if(recList[k].fieldName == "buildertek__Profit_Loss__c"){
                                                         obj['ProfitLoss'] += recList[k].originalValue;
                                                         obj['ProfitLosskey'] = 'buildertek__Profit_Loss__c'
                                                     }
                                                     obj['fieldType'] = recList[k].fieldType;
                                                 }
                                                 
                                                /* if(recList[k].fieldType == "currency" && 
                                                    recList[k].fieldName != "buildertek__Original_Budget__c"){
                                                     obj['orignalbudget'] += recList[k].originalValue;
                                                 }if(recList[k].fieldType == "currency" && recList[k].originalValue != '' && 
                                                    recList[k].fieldName != "buildertek__Total_Approvals_CO__c"){
                                                     obj['TotalApprovals'] += recList[k].originalValue;
                                                 }if(recList[k].fieldType == "currency" && recList[k].originalValue != '' && 
                                                    recList[k].fieldName != "buildertek__Committed_Costs__c"){
                                                     alert('recList[k].originalValue'+recList[k].originalValue);
                                                     obj['commitedcost'] += recList[k].originalValue;
                                                 }*/
                                             }
                                             
                                             listOfRecords[i]['totals'] = obj;
                                         }
                                     }
                                    console.log(listOfRecords)
                                    component.set("v.listOfRecords",listOfRecords);
                                    return listOfRecords;
                                   // alert(listOfRecords);
                                }
                                 function subGroupRecords(data) {
                                    var listOfRecords = [];
                                    var recordValue = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                        for(var j in data[i].recordList){
                                        console.log('data[i].recordList[j]',data[i].recordList);
                                        /*if(data[i].recordList[j].fieldName == 'buildertek__Contractor__c' && data[i].recordList[j].originalValue == ''){
                                            data[i].recordList[j].originalValue = 'No Vendor';
                                          
                                            if (!recordsMap.has('' + '(#&%*)' + 'No Vendor')) {
                                                recordsMap.set('' + '(#&%*)' + 'No Vendor', []);
                                            }
                                            //console.log(recordsMap.has('No vendor'),recordsMap.get("No vendor"))
                                            recordsMap.get('' + '(#&%*)' + 'No Vendor').push(JSON.parse(JSON.stringify(data[i])))
                                            //recordsMap.get('No Vendor').push(JSON.parse(JSON.stringify(data[i])));
                                        }*/
                                            if(data[i].recordList[j].fieldName == 'buildertek__Contractor__c' && data[i].recordList[j].originalValue != ''){
                                                 console.log('data[i].recordList[j].fieldName',data[i].recordList[j].fieldName);
                                                console.log('data[i].recordList[j].originalValue',data[i].recordList[j].originalValue);
                                                if (!recordsMap.has(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue)) {
                                                    recordsMap.set(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue, []);
                                                }
                                                recordsMap.get(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue).push(JSON.parse(JSON.stringify(data[i])));
                                                
                                            }
                                        }
                                    }
                                    
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        var recordValue = [];
                                        obj.recordValue = [];
                                        var sumCol = 0;
                                        obj.subGroupId = result[i][0].split('(#&%*)')[0];
                                        obj.subGroupName = result[i][0].split('(#&%*)')[1] == undefined ? 'No Grouping' : result[i][0].split('(#&%*)')[1];
                                        obj.records = result[i][1];
                                        if (obj.subGroupName != 'No Grouping') {
                                            for (var j in obj.records) {
                                                console.log(obj.records[j].recordValue);
                                                recordValue.push(obj.records[j].recordValue);
                                            }
                                            var row = recordValue.length;
                                            var col = recordValue[0].length;
                                            for (var j = 0; j < col; j++) {
                                                sumCol = 0;
                                                for (var k = 0; k < row; k++) {
                                                    console.log(recordValue[k][j])
                                                    sumCol += recordValue[k][j];
                                                }
                                                j == 0 ?
                                                    obj.recordValue.push(sumCol) :
                                                obj.recordValue.push(new Intl.NumberFormat('en-US', {
                                                    style: 'currency',
                                                    currency: 'USD'
                                                }).format(sumCol));
                                            }
                                        }
                                        listOfRecords.push(obj);
                                    }
                                      
                                     console.log('listOfRecords',listOfRecords);
                                    return listOfRecords;
                                    
                                }
                              
                            }
                     
                        }
                        else{
                            if(bt1 == true ){
                            if(toggleVal2){
                            if (result.tarTable != undefined && result.tarTable.ListOfEachRecord != undefined) {
                                var records = result.tarTable.ListOfEachRecord;
                                result.groupHierarchy = groupRecords(records);
                              // alert(JSON.stringify(records)); 
                                function groupRecords(data) {
                                    var listOfRecords = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                      // alert(!recordsMap.has(data[i].groupId + '(#&%*)' + data[i].groupName));
                                        if(data[i].groupId != undefined && data[i].groupName != undefined){
                                        if (!recordsMap.has(data[i].groupId + '(#&%*)' + data[i].groupName)) {
                                            recordsMap.set(data[i].groupId + '(#&%*)' + data[i].groupName, []);
                                        }
                                        recordsMap.get(data[i].groupId + '(#&%*)' + data[i].groupName).push(JSON.parse(JSON.stringify(data[i])));
                                         }else if(data[i].groupId == undefined && data[i].groupName == undefined){
                                            data[i].groupName = 'No Grouping';
                                         }
                                    }
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        obj.groupId = result[i][0].split('(#&%*)')[0];
                                        obj.groupName = result[i][0].split('(#&%*)')[1];
                                        //alert('group id'+obj.groupId);
                                       // alert('result'+ JSON.stringify(result[i][1]));
                                      // alert( 'gropu name'+obj.groupName);
                                        obj.subGroupRecords = subGroupRecords(result[i][1]);
                                       // alert( JSON.stringify(obj.subGroupRecords));
                                        listOfRecords.push(obj);
                                        
                                    }
                                    return listOfRecords;
                                }
                                
                                function subGroupRecords(data) {
                                    var listOfRecords = [];
                                    var recordValue = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                        if (!recordsMap.has(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping')) {
                                            recordsMap.set(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping', []);
                                        }
                                        recordsMap.get(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping').push(JSON.parse(JSON.stringify(data[i])));
                                    }
                                    
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        var recordValue = [];
                                        obj.recordValue = [];
                                        var sumCol = 0;
                                        obj.subGroupId = result[i][0].split('(#&%*)')[0];
                                        obj.subGroupName = result[i][0].split('(#&%*)')[1] == undefined ? 'No Grouping' : result[i][0].split('(#&%*)')[1];
                                        obj.records = result[i][1];
                                        if (obj.subGroupName != 'No Grouping') {
                                            for (var j in obj.records) {
                                                console.log(obj.records[j].recordValue);
                                                recordValue.push(obj.records[j].recordValue);
                                            }
                                            var row = recordValue.length;
                                            var col = recordValue[0].length;
                                            for (var j = 0; j < col; j++) {
                                                sumCol = 0;
                                                for (var k = 0; k < row; k++) {
                                                    console.log(recordValue[k][j])
                                                    sumCol += recordValue[k][j];
                                                }
                                                j == 0 ?
                                                    obj.recordValue.push(sumCol) :
                                                obj.recordValue.push(new Intl.NumberFormat('en-US', {
                                                    style: 'currency',
                                                    currency: 'USD'
                                                }).format(sumCol));
                                            }
                                        }
                                        listOfRecords.push(obj);
                                    }
                                    return listOfRecords;
                                }
                            }
                            }
                            }
                             if(bt1 == false ){
                                     if(toggleVal1){
                            if (result.tarTable != undefined && result.tarTable.ListOfEachRecord != undefined) {
                                var records = result.tarTable.ListOfEachRecord;
                                result.groupHierarchy = groupRecords(records);
                              // alert(JSON.stringify(records)); 
                                function groupRecords(data) {
                                    var listOfRecords = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                          if(data[i].groupId != undefined && data[i].groupName != undefined){
                                        if (!recordsMap.has(data[i].groupId + '(#&%*)' + data[i].groupName)) {
                                            recordsMap.set(data[i].groupId + '(#&%*)' + data[i].groupName, []);
                                        }
                                        recordsMap.get(data[i].groupId + '(#&%*)' + data[i].groupName).push(JSON.parse(JSON.stringify(data[i])));
                                               }else if(data[i].groupId == undefined && data[i].groupName == undefined){
                                            data[i].groupName = 'No Grouping';
                                         }
                                    
                                    }
                                        
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        obj.groupId = result[i][0].split('(#&%*)')[0];
                                        obj.groupName = result[i][0].split('(#&%*)')[1];
                                        obj.subGroupRecords = subGroupRecords(result[i][1]);
                                        listOfRecords.push(obj);
                                        
                                    }
                                    return listOfRecords;
                                }
                                
                                function subGroupRecords(data) {
                                    var listOfRecords = [];
                                    var recordValue = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                        if (!recordsMap.has(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping')) {
                                            recordsMap.set(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping', []);
                                        }
                                        recordsMap.get(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping').push(JSON.parse(JSON.stringify(data[i])));
                                    }
                                    
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        var recordValue = [];
                                        obj.recordValue = [];
                                        var sumCol = 0;
                                        obj.subGroupId = result[i][0].split('(#&%*)')[0];
                                        obj.subGroupName = result[i][0].split('(#&%*)')[1] == undefined ? 'No Grouping' : result[i][0].split('(#&%*)')[1];
                                        obj.records = result[i][1];
                                        if (obj.subGroupName != 'No Grouping') {
                                            for (var j in obj.records) {
                                                console.log(obj.records[j].recordValue);
                                                recordValue.push(obj.records[j].recordValue);
                                            }
                                            var row = recordValue.length;
                                            var col = recordValue[0].length;
                                            for (var j = 0; j < col; j++) {
                                                sumCol = 0;
                                                for (var k = 0; k < row; k++) {
                                                    console.log(recordValue[k][j])
                                                    sumCol += recordValue[k][j];
                                                }
                                                j == 0 ?
                                                    obj.recordValue.push(sumCol) :
                                                obj.recordValue.push(new Intl.NumberFormat('en-US', {
                                                    style: 'currency',
                                                    currency: 'USD'
                                                }).format(sumCol));
                                            }
                                        }
                                        listOfRecords.push(obj);
                                    }
                                    return listOfRecords;
                                }
                            }
                            }
                                    
                                }
                              if(bt1 == true && toggleVal2 == true ){
                            if(toggleVal1){
                            if (result.tarTable != undefined && result.tarTable.ListOfEachRecord != undefined) {
                                var records = result.tarTable.ListOfEachRecord;
                                result.groupHierarchy = groupRecords(records);
                              // alert(JSON.stringify(records)); 
                                function groupRecords(data) {
                                    var listOfRecords = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                         if(data[i].groupId != undefined && data[i].groupName != undefined){
                                        if (!recordsMap.has(data[i].groupId + '(#&%*)' + data[i].groupName)) {
                                            recordsMap.set(data[i].groupId + '(#&%*)' + data[i].groupName, []);
                                        }
                                        recordsMap.get(data[i].groupId + '(#&%*)' + data[i].groupName).push(JSON.parse(JSON.stringify(data[i])));
                                         }else if(data[i].groupId == undefined && data[i].groupName == undefined){
                                            data[i].groupName = 'No Grouping';
                                         }
                                    
                                    }
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        obj.groupId = result[i][0].split('(#&%*)')[0];
                                        obj.groupName = result[i][0].split('(#&%*)')[1];
                                        obj.subGroupRecords = subGroupRecords(result[i][1]);
                                        listOfRecords.push(obj);
                                        
                                    }
                                    return listOfRecords;
                                }
                                
                                function subGroupRecords(data) {
                                    var listOfRecords = [];
                                    var recordValue = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                        if (!recordsMap.has(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping')) {
                                            recordsMap.set(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping', []);
                                        }
                                        recordsMap.get(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping').push(JSON.parse(JSON.stringify(data[i])));
                                    }
                                    
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        var recordValue = [];
                                        obj.recordValue = [];
                                        var sumCol = 0;
                                        obj.subGroupId = result[i][0].split('(#&%*)')[0];
                                        obj.subGroupName = result[i][0].split('(#&%*)')[1] == undefined ? 'No Grouping' : result[i][0].split('(#&%*)')[1];
                                        obj.records = result[i][1];
                                        if (obj.subGroupName != 'No Grouping') {
                                            for (var j in obj.records) {
                                                console.log(obj.records[j].recordValue);
                                                recordValue.push(obj.records[j].recordValue);
                                            }
                                            var row = recordValue.length;
                                            var col = recordValue[0].length;
                                            for (var j = 0; j < col; j++) {
                                                sumCol = 0;
                                                for (var k = 0; k < row; k++) {
                                                    console.log(recordValue[k][j])
                                                    sumCol += recordValue[k][j];
                                                }
                                                j == 0 ?
                                                    obj.recordValue.push(sumCol) :
                                                obj.recordValue.push(new Intl.NumberFormat('en-US', {
                                                    style: 'currency',
                                                    currency: 'USD'
                                                }).format(sumCol));
                                            }
                                        }
                                        listOfRecords.push(obj);
                                    }
                                    return listOfRecords;
                                }
                            }
                            }
                            }
                             if(bt1 == false && toggleVal2 == false){
                                    
                                     if(toggleVal1){
                            if (result.tarTable != undefined && result.tarTable.ListOfEachRecord != undefined) {
                                var records = result.tarTable.ListOfEachRecord;
                                result.groupHierarchy = groupRecords(records);
                              // alert(JSON.stringify(records)); 
                                function groupRecords(data) {
                                    var listOfRecords = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                         if(data[i].groupId != undefined && data[i].groupName != undefined){
                                        if (!recordsMap.has(data[i].groupId + '(#&%*)' + data[i].groupName)) {
                                            recordsMap.set(data[i].groupId + '(#&%*)' + data[i].groupName, []);
                                        }
                                        recordsMap.get(data[i].groupId + '(#&%*)' + data[i].groupName).push(JSON.parse(JSON.stringify(data[i])));
                                         }else if(data[i].groupId == undefined && data[i].groupName == undefined){
                                            data[i].groupName = 'No Grouping';
                                         }
                                    
                                    }
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        obj.groupId = result[i][0].split('(#&%*)')[0];
                                        obj.groupName = result[i][0].split('(#&%*)')[1];
                                        obj.subGroupRecords = subGroupRecords(result[i][1]);
                                        listOfRecords.push(obj);
                                        
                                    }
                                    return listOfRecords;
                                }
                                
                                function subGroupRecords(data) {
                                    var listOfRecords = [];
                                    var recordValue = [];
                                    let recordsMap = new Map();
                                    for (var i in data) {
                                        if (!recordsMap.has(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping')) {
                                            recordsMap.set(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping', []);
                                        }
                                        recordsMap.get(data[i].subGroupId != undefined ? data[i].subGroupId + '(#&%*)' + data[i].subGroupName : 'No Grouping').push(JSON.parse(JSON.stringify(data[i])));
                                    }
                                    
                                    var result = Array.from(recordsMap.entries());
                                    for (var i in result) {
                                        var obj = {};
                                        var recordValue = [];
                                        obj.recordValue = [];
                                        var sumCol = 0;
                                        obj.subGroupId = result[i][0].split('(#&%*)')[0];
                                        obj.subGroupName = result[i][0].split('(#&%*)')[1] == undefined ? 'No Grouping' : result[i][0].split('(#&%*)')[1];
                                        obj.records = result[i][1];
                                        if (obj.subGroupName != 'No Grouping') {
                                            for (var j in obj.records) {
                                                console.log(obj.records[j].recordValue);
                                                recordValue.push(obj.records[j].recordValue);
                                            }
                                            var row = recordValue.length;
                                            var col = recordValue[0].length;
                                            for (var j = 0; j < col; j++) {
                                                sumCol = 0;
                                                for (var k = 0; k < row; k++) {
                                                    console.log(recordValue[k][j])
                                                    sumCol += recordValue[k][j];
                                                }
                                                j == 0 ?
                                                    obj.recordValue.push(sumCol) :
                                                obj.recordValue.push(new Intl.NumberFormat('en-US', {
                                                    style: 'currency',
                                                    currency: 'USD'
                                                }).format(sumCol));
                                            }
                                        }
                                        listOfRecords.push(obj);
                                    }
                                    return listOfRecords;
                                }
                            }
                            }
                             }
                            
                            else{
                                 if(bt1 == true && toggleVal2 == false ){
                                if (result.tarTable != undefined && result.tarTable.ListOfEachRecord != undefined) {
                                    var records = result.tarTable.ListOfEachRecord;
                                    result.groupHierarchy = groupRecords(records);
                                    function groupRecords(data) {
                                        var listOfRecords = [];
                                        let recordsMap = new Map();
                                        for (var i in data) {
                                            for(var j in data[i].recordList){
                                                if(data[i].recordList[j].fieldName == 'buildertek__CostCodeDivision__c' && data[i].recordList[j].originalValue != ''){
                                                     
                                                    if (!recordsMap.has(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue)) {
                                                        recordsMap.set(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue, []);
                                                    }
                                                    recordsMap.get(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue).push(JSON.parse(JSON.stringify(data[i])));
                                                }else if(data[i].recordList[j].fieldName == 'buildertek__CostCodeDivision__c' && data[i].recordList[j].originalValue == ''){
                                                    
                                                    data[i].recordList[j].originalValue = 'No Cost Code';
                                                    if (!recordsMap.has('No Cost Code' + '(#&%*)' + 'No Cost Code')) {
                                                        recordsMap.set('No Cost Code' + '(#&%*)' + 'No Cost Code', []);
                                                    }
                                                    recordsMap.get('No Cost Code' + '(#&%*)' + 'No Cost Code').push(JSON.parse(JSON.stringify(data[i]))) 
                                                }
                                            }
                                        }
                                        var result = Array.from(recordsMap.entries());
                                        for (var i in result) {
                                            var obj = {};
                                            obj.groupId = result[i][0].split('(#&%*)')[1];
                                           // alert(obj.groupId);
                                            obj.groupName = result[i][0].split('(#&%*)')[0];
                                          //  alert(obj.groupName);
                                            obj.subGroupRecords = subGroupRecords(result[i][1]);
                                            listOfRecords.push(obj);
                                            
                                        }
                                        for(var i in listOfRecords){
                                            var obj = {}
                                            obj['unitPrice'] = 0;
                                            obj['unitPricekey'] = '';
                                            obj['orignalbudget'] = 0;
                                            obj['orignalbudgetkey'] = '';
                                            obj['TotalApprovals'] = 0;
                                            obj['TotalApprovalskey'] = '';
                                            obj['CommittedCost'] = 0;
                                            obj['CommittedCostkey'] = 0;
                                            obj['AdditionalCosts'] = 0;
                                            obj['AdditionalCostsKey'] = '';
                                            obj['InvoiceCosts'] = 0;
                                            obj['InvoiceCostsKey'] = '';
                                            obj['ProjectedCosts'] = 0;
                                            obj['ProjectedCostskey'] = '';
                                            obj['Labor1'] = 0;
                                            obj['Labor1key'] = '';
                                            obj['Forecast'] = 0;
                                            obj['Forecastskey'] = '';
                                            obj['TotalCosts'] = 0;
                                            obj['TotalCostsKey'] = '';
                                            obj['ProfitLoss'] = 0;
                                            obj['ProfitLosskey'] = '';
                                            obj['fieldType'] = '';
                                            for(var j=0;j<listOfRecords[i].subGroupRecords[0].records.length;j++){
                                                console.log(listOfRecords[i].subGroupRecords[0].records[j])
                                                var recList = listOfRecords[i].subGroupRecords[0].records[j].recordList;
                                              // alert('recList...............'+ JSON.stringify(recList));
                                                for(var k = 0;k<recList.length;k++){
                                                    //alert(JSON.stringify(recList[k]));
                                                    if(recList[k].fieldType == "currency"){
                                                        if(recList[k].fieldName == "buildertek__Unit_Price__c"){
                                                            obj['unitPrice'] += Number(recList[k].originalValue);
                                                           // alert( obj['unitPrice']);
                                                            obj['unitPricekey'] = "buildertek__Unit_Price__c"
                                                          //  alert( obj['unitPricekey']);
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Original_Budget__c"){
                                                            obj['orignalbudget'] += recList[k].originalValue;
                                                            obj['orignalbudgetkey'] = "buildertek__Original_Budget__c"
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Total_Approvals_CO__c"){
                                                            obj['TotalApprovals'] += recList[k].originalValue;
                                                            obj['TotalApprovalskey'] = 'buildertek__Total_Approvals_CO__c'
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Committed_Costs__c"){
                                                            obj['CommittedCost'] += recList[k].originalValue;
                                                            obj['CommittedCostkey'] = 'buildertek__Committed_Costs__c'
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Additional_Costs__c"){
                                                            obj['AdditionalCosts'] += recList[k].originalValue;
                                                            obj['AdditionalCostsKey'] = "buildertek__Additional_Costs__c"
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Invoice_total__c"){
                                                            obj['InvoiceCosts'] += recList[k].originalValue;
                                                            obj['InvoiceCostsKey'] = "buildertek__Invoice_total__c"
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Labor1__c"){
                                                            obj['Labor1'] += recList[k].originalValue;
                                                            obj['Labor1key'] = 'buildertek__Labor1__c'
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Projected_Costs__c"){
                                                            obj['ProjectedCosts'] += recList[k].originalValue;
                                                            obj['ProjectedCostskey'] = 'buildertek__Projected_Costs__c'
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Forecast_To_Complete__c"){
                                                            obj['Forecast'] += recList[k].originalValue;
                                                            obj['Forecastskey'] = 'buildertek__Forecast_To_Complete__c'
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Total_Costs__c"){
                                                            obj['TotalCosts'] +=  recList[k].originalValue;
                                                            obj['TotalCostsKey'] = 'buildertek__Total_Costs__c'
                                                        }
                                                        if(recList[k].fieldName == "buildertek__Profit_Loss__c"){
                                                            obj['ProfitLoss'] += recList[k].originalValue;
                                                            obj['ProfitLosskey'] = 'buildertek__Profit_Loss__c'
                                                        }
                                                        obj['fieldType'] = recList[k].fieldType;
                                                       // alert( obj['fieldType']);
                                                    }
                                                    
                                                    /* if(recList[k].fieldType == "currency" && 
                                                    recList[k].fieldName != "buildertek__Original_Budget__c"){
                                                     obj['orignalbudget'] += recList[k].originalValue;
                                                 }if(recList[k].fieldType == "currency" && recList[k].originalValue != '' && 
                                                    recList[k].fieldName != "buildertek__Total_Approvals_CO__c"){
                                                     obj['TotalApprovals'] += recList[k].originalValue;
                                                 }if(recList[k].fieldType == "currency" && recList[k].originalValue != '' && 
                                                    recList[k].fieldName != "buildertek__Committed_Costs__c"){
                                                     alert('recList[k].originalValue'+recList[k].originalValue);
                                                     obj['commitedcost'] += recList[k].originalValue;
                                                 }*/
                                             }
                                             
                                             listOfRecords[i]['totals'] = obj;
                                         }
                                    }
                                    console.log(listOfRecords)
                                    component.set("v.listOfRecords",listOfRecords);
                                    return listOfRecords;
                                }
                                     function subGroupRecords(data) {
                                         var listOfRecords = [];
                                         var recordValue = [];
                                         let recordsMap = new Map();
                                         for (var i in data) {
                                             for(var j in data[i].recordList){
                                                 console.log('data[i].recordList[j]',data[i].recordList);
                                            if(data[i].recordList[j].fieldName == 'buildertek__CostCodeDivision__c' && data[i].recordList[j].originalValue != ''){
                                                console.log('data[i].recordList[j].fieldName',data[i].recordList[j].fieldName);
                                                console.log('data[i].recordList[j].originalValue',data[i].recordList[j].originalValue);
                                                if (!recordsMap.has(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue)) {
                                                    recordsMap.set(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue, []);
                                                }
                                                recordsMap.get(data[i].recordList[j].originalValue + '(#&%*)' + data[i].recordList[j].referenceValue).push(JSON.parse(JSON.stringify(data[i])));
                                            }
                                        }
                                    }
                                     
                                     var result = Array.from(recordsMap.entries());
                                     for (var i in result) {
                                         var obj = {};
                                         var recordValue = [];
                                         obj.recordValue = [];
                                         var sumCol = 0;
                                         obj.subGroupId = result[i][0].split('(#&%*)')[0];
                                         obj.subGroupName = result[i][0].split('(#&%*)')[1] == undefined ? 'No Grouping' : result[i][0].split('(#&%*)')[1];
                                         obj.records = result[i][1];
                                         if (obj.subGroupName != 'No Grouping' ) {
                                             for (var j in obj.records) {
                                                 console.log(obj.records[j].recordValue);
                                                 recordValue.push(obj.records[j].recordValue);
                                             }
                                             var row = recordValue.length;
                                             var col = recordValue[0].length;
                                             for (var j = 0; j < col; j++) {
                                                 sumCol = 0;
                                                 for (var k = 0; k < row; k++) {
                                                     console.log(recordValue[k][j])
                                                     sumCol += recordValue[k][j];
                                                 }
                                                 j == 0 ?
                                                     obj.recordValue.push(sumCol) :
                                                 obj.recordValue.push(new Intl.NumberFormat('en-US', {
                                                     style: 'currency',
                                                     currency: 'USD'
                                                 }).format(sumCol));
                                             }
                                         }
                                         listOfRecords.push(obj);
                                     }
                                     
                                     console.log('listOfRecords',listOfRecords);
                                     return listOfRecords;
                                     
                                 }
                                     
                                 }
                                
                                 }
                                
                                
                                
                            }
                            
                        }
                    }
                    component.set("v.columns", result.columns);
                    component.set("v.page", result.page);
                    component.set("v.total", result.total);
                    //alert(result.total);
                    if (result.total == 0) {
                        component.set("v.pages", 1);
                    } else {
                        component.set("v.pages", Math.ceil(result.total / 60));
                    }
                    //component.set("v.isLoaded", true);
                    component.set("v.TotalRecords", result);
                    component.set("v.TotalRecordsCopy",result);
                    console.log('budget lines::',result);
                    
                    
                   
                   $A.get("e.c:BT_SpinnerEvent").setParams({
                        action: "HIDE",
                    }).fire();
                    //var end = new Date().getTime();
                    //console.log(end - start);
                } else {
                    $A.get("e.c:BT_SpinnerEvent").setParams({
                        action: "HIDE",
                    }).fire();
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        }
    },

    /*getProductDetails:function(component,event,helper){
          var action = component.get("c.getProductPrice");
          var productId = component.get("v.productId");
          var productName = component.get("v.productName");
          ////console.log("----productId",productId);
          action.setParams({"productId":productId});
          action.setCallback(this,function(respo){
              var res = respo.getReturnValue(); 
              ////console.log("----respo---",res.length);
              var getProductDetails = component.get("v.newBudgetLine");
              delete getProductDetails.buildertek__Grouping__r;
              ////console.log("@Budgetline@",component.get("v.recordId"));
              getProductDetails.buildertek__Budget__c = component.get("v.recordId");
              ////console.log("getprodct----",JSON.stringify(getProductDetails));
              if(res.length>=1) {
                  getProductDetails.buildertek__Unit_Price__c = res[0].UnitPrice;
              }else{
                  getProductDetails.buildertek__Unit_Price__c = 0;
              }
              getProductDetails.buildertek__Product__c = productId;
              
              getProductDetails.Name = productName;
              component.set("v.newBudgetLine",getProductDetails);
              
              ////console.log("getprodct----",JSON.stringify(getProductDetails));
              
              ////console.log("----log",res);
          });
          $A.enqueueAction(action);
      },*/

    getGrouping: function (component, event, fieldsList, allFields, groupIds) {
        var recordId = component.get("v.recordId");

        var action = component.get("c.groupValues");
        action.setParams({
            recordId: recordId,
            currencyFields: fieldsList,
            allFields: allFields,
            groupIds: groupIds,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //alert('state -------->'+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
            console.log('result --------> '+JSON.stringify(result));
                component.set("v.InnerList", result);
                $A.get("e.c:BT_SpinnerEvent")
                    .setParams({
                        action: "HIDE",
                    })
                    .fire();
            }
        });
        $A.enqueueAction(action);
    },

    getTableData: function (component, event, allFields, fieldType) {
        var recordId = component.get("v.recordId");
        allFields.push("Id", "buildertek__Group__c");
        fieldType.push({
            fieldName: "Id",
            fieldType: "",
            isEditable: false,
        });
        fieldType.push({
            fieldName: "buildertek__Group__c",
            fieldType: "Reference",
            isEditable: false,
        });
        var finalString = JSON.stringify(fieldType);
       // alert(finalString);
        var action = component.get("c.getBudgetItemData");
        action.setParams({
            recordId: recordId,
            fieldsList: allFields,
            fieldString: finalString,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
           // alert('state -------> '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                ////console.log('Final result --------> '+JSON.stringify(result));
                component.set("v.Table_header_Records", result);
            }
        });
        $A.enqueueAction(action);
    },

    fetchpricebooks: function (component, event, helper) {
        var action = component.get("c.getpricebook");
        action.setParams({
            BudgetId: component.get("v.recordId"),
        });
        var opts = [];
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.pricebookName", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        var actions = component.get("c.getpricebooks");
        var opts = [];
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                var opts = [];
                opts.push({
                    key: "None",
                    value: "",
                });
                for (var key in result) {
                    opts.push({
                        key: key,
                        value: result[key],
                    });
                }
                component.set("v.pricebookoptions", opts);
            }
        });
        $A.enqueueAction(actions);
    },

    fetchPickListVal: function (component, event, helper) {
        var actions = component.get("c.getselectOptions");
        actions.setParams({
            budgetObject: component.get("v.newBudgetLine"),
            budgetField: "buildertek__UOM__c",
        });
        var opts = [];
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                var opts = [];
                opts.push({
                    key: "None",
                    value: "",
                });
                for (var key in result) {
                    opts.push({
                        key: key,
                        value: result[key],
                    });
                }
                component.set("v.options", opts);
            }
        });
        $A.enqueueAction(actions);
    },

    fetchPriority: function (component, event, helper) {
        var actions = component.get("c.getselectOptions");
        actions.setParams({
            budgetObject: component.get("v.newBudgetLine"),
            budgetField: "buildertek__Priority__c",
        });
        var opts = [];
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                var opts = [];
                opts.push({
                    key: "None",
                    value: "",
                });
                for (var key in result) {
                    opts.push({
                        key: key,
                        value: result[key],
                    });
                }
                component.set("v.priorityOptions", opts);
            }
        });
        $A.enqueueAction(actions);
    },

    fetchproductfamily: function (component, event, helper) {
        var actions = component.get("c.getselectOptionsforproductfamily");
        actions.setParams({
            budgetObject: "Product2",
            budgetField: "Family",
        });
        var opts = [];
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                var opts = [];
                //opts.push({key: "None", value: "" });
                for (var key in result) {
                    opts.push({
                        key: key,
                        value: result[key],
                    });
                }
                component.set("v.productfamilyoptions", opts);
            }
        });
        $A.enqueueAction(actions);
    },
    doSave: function (component, event, helper) {
		debugger;
		$A.get("e.c:BT_SpinnerEvent").setParams({
			"action": "SHOW"
		}).fire();
		component.set("v.isNewExpense", false);
        component.set("v.duplicateExp", false);
		var expenseDescription = component.get("v.expenseDescription");
		var expensebudget = component.get("v.expensebudget");
		var expenseType = component.get("v.expenseType");
		var expenseCostCode = component.get("v.expenseCostCode");
		var expensePaymentMethod = component.get("v.expensePaymentMethod");
		var expenseRefNo = component.get("v.expenseRefNo");
		var expenseAmount = component.get("v.expenseAmount");
		var expenseNote = component.get("v.expenseNote");
		var isExpenseUpdate = component.get("v.isExpenseUpdate");
		var budgetItemId = component.get("v.budgetItemId");
       var proj =  component.get("v.sampleNewRecord");
       // alert( JSON.stringify(proj));
      //  alert('kkkkk'+component.get("v.sampleNewRecord").buildertek__Project__c);
      //  alert(budgetItemId);
       	if(budgetItemId){
           // isExpenseUpdate = true;
        }
		//Update Expense  
		if (budgetItemId != undefined && isExpenseUpdate) {
			var action = component.get("c.updateBudgetItemFromExpenseItem");
         //  alert('^^^');
			action.setParams({
				"expenseDescription": expenseDescription,
				"expensebudgetId": expensebudget,
				"expenseType": expenseType,
				"expenseCostCode": expenseCostCode,
				"expensePaymentMethod": expensePaymentMethod,
				"expenseRefNo": expenseRefNo,
				"expenseAmount": expenseAmount,
				"expenseNote": expenseNote,
				"projectId": component.get("v.sampleNewRecord").buildertek__Project__c,
				'budgetItemId': budgetItemId
			});
			action.setCallback(this, function (response) {
                var responses = response.getReturnValue();
				if (responses != null) {
					$A.get("e.c:BT_SpinnerEvent").setParams({
						"action": "HIDE"
					}).fire();
                  //  alert('hai'+response.getState() );
					//$A.getCallback(function () {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'Budget Line created successfully',
							type: 'success',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					//});
					$A.get('e.force:refreshView').fire();
					component.refreshData();
					component.set("v.expenseDescription", null);
					component.set("v.expensebudget", null);
					component.set("v.expenseType", null);
					component.set("v.expenseCostCode", null);
					component.set("v.expensePaymentMethod", null);
					component.set("v.expenseRefNo", null);
					component.set("v.expenseAmount", null);
					component.set("v.expenseNote", null);
                    component.set("v.budgetItemId", null);
                    var noRecord = [];
                    component.set('v.selectedRecs', noRecord);
                    //alert("@@3"+component.get("v.budgetItemId"));
				} 
                else 
                    /*if (response.getState() === "ERROR") {
					let errors = response.getError();
					let message = 'Unknown error'; // Default error message
					// Retrieve the error message sent by the server
					if (errors && Array.isArray(errors) && errors.length > 0) {
						message = errors[0].message;
					}
					// Display the message
					console.error(message);
					$A.getCallback(function () {*/
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'We cannot create New Expense, because this Budget has not associated with the Project.',
							type: 'ERROR',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					//});
					$A.get('e.force:refreshView').fire();
				//}
			});
			$A.enqueueAction(action);
            //alert("@@2"+component.get("v.budgetItemId"));
		} 
        else {
          //  alert('hello');
			var action = component.get("c.createBudgetItemFromExpenseItem");
			action.setParams({
				"expenseDescription": expenseDescription,
				"expensebudgetId": expensebudget,
				"expenseType": expenseType,
				"expenseCostCode": expenseCostCode,
				"expensePaymentMethod": expensePaymentMethod,
				"expenseRefNo": expenseRefNo,
				"expenseAmount": expenseAmount,
				"expenseNote": expenseNote,
				"projectId": component.get("v.sampleNewRecord").buildertek__Project__c
			});
			action.setCallback(this, function (response) {
                  var res = response.getReturnValue();
			//	if (response.getState() === "SUCCESS") {
					$A.get("e.c:BT_SpinnerEvent").setParams({
						"action": "HIDE"
					}).fire();
					//$A.getCallback(function () {
                  if (res != null) {
					//alert('oye'+response.getReturnValue());
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'Budget Line created successfully',
							type: 'success',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					//});
					$A.get('e.force:refreshView').fire();
					component.refreshData();
					component.set("v.expenseDescription", null);
					component.set("v.expensebudget", null);
					component.set("v.expenseType", null);
					component.set("v.expenseCostCode", null);
					component.set("v.expensePaymentMethod", null);
					component.set("v.expenseRefNo", null);
					component.set("v.expenseAmount", null);
					component.set("v.expenseNote", null);
                    component.set("v.budgetItemId", null);
                  } else {
                  //  alert("helo......");
                    /*if (response.getState() === "ERROR") {
					let errors = response.getError();
					let message = 'Unknown error'; // Default error message
					// Retrieve the error message sent by the server
					if (errors && Array.isArray(errors) && errors.length > 0) {
						message = errors[0].message;
					}
					// Display the message
					console.error(message);*/
					//$A.getCallback(function () {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'We cannot create New Expense, because this Budget has not associated with the Project.',
							type: 'ERROR',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					//});
					$A.get('e.force:refreshView').fire();
                  }
				//}
                //}
			});
			$A.enqueueAction(action);
		}

	},
    getpoList : function (component, pageNumber, pageSize) {
        var recId = component.get("v.recordId");
        var action = component.get("c.getBudgetData");
        action.setParams({
          pageNumber: pageNumber,
          pageSize: pageSize,
          RecId : recId
        });
        action.setCallback(this, function (result) {
          var state = result.getState();
          if (component.isValid() && state === "SUCCESS") {
            var resultData = result.getReturnValue();
            for(var i in resultData.recordList){
                resultData.recordList[i].budgetCheck =false;
            }
            component.set("v.recordList", resultData.recordList);
            component.set("v.PageNumber", resultData.pageNumber);
            component.set("v.TotalRecord", resultData.totalRecords);
            component.set("v.RecordStart", resultData.recordStart);
            component.set("v.RecordEnd", resultData.recordEnd);
            component.set(
              "v.TotalPages",
              Math.ceil(resultData.totalRecords / pageSize)
            );
          }
        });
        $A.enqueueAction(action);
  },
  /*  doSave: function (component, event, helper) {
		debugger;
		$A.get("e.c:BT_SpinnerEvent").setParams({
			"action": "SHOW"
		}).fire();
		component.set("v.isNewExpense", false);
        component.set("v.duplicateExp", false);
		var expenseDescription = component.get("v.expenseDescription");
		var expensebudget = component.get("v.expensebudget");
		var expenseType = component.get("v.expenseType");
		var expenseCostCode = component.get("v.expenseCostCode");
		var expensePaymentMethod = component.get("v.expensePaymentMethod");
		var expenseRefNo = component.get("v.expenseRefNo");
		var expenseAmount = component.get("v.expenseAmount");
		var expenseNote = component.get("v.expenseNote");
		var isExpenseUpdate = component.get("v.isExpenseUpdate");
		var budgetItemId = component.get("v.budgetItemId");
		//Update Expense  
		if (budgetItemId != undefined && isExpenseUpdate) {
			var action = component.get("c.updateBudgetItemFromExpenseItem");
			action.setParams({
				"expenseDescription": expenseDescription,
				"expensebudgetId": expensebudget,
				"expenseType": expenseType,
				"expenseCostCode": expenseCostCode,
				"expensePaymentMethod": expensePaymentMethod,
				"expenseRefNo": expenseRefNo,
				"expenseAmount": expenseAmount,
				"expenseNote": expenseNote,
				"projectId": component.get("v.sampleNewRecord").buildertek__Project__c,
				'budgetItemId': budgetItemId
			});
			action.setCallback(this, function (response) {
				if (response.getState() === "SUCCESS") {
					$A.get("e.c:BT_SpinnerEvent").setParams({
						"action": "HIDE"
					}).fire();
					$A.getCallback(function () {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'Budget Line created successfully',
							type: 'success',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					});
					$A.get('e.force:refreshView').fire();
					component.refreshData();
					component.set("v.expenseDescription", null);
					component.set("v.expensebudget", null);
					component.set("v.expenseType", null);
					component.set("v.expenseCostCode", null);
					component.set("v.expensePaymentMethod", null);
					component.set("v.expenseRefNo", null);
					component.set("v.expenseAmount", null);
					component.set("v.expenseNote", null);
                    component.set("v.budgetItemId", '');
				} else if (response.getState() === "ERROR") {
					let errors = response.getError();
					let message = 'Unknown error'; // Default error message
					// Retrieve the error message sent by the server
					if (errors && Array.isArray(errors) && errors.length > 0) {
						message = errors[0].message;
					}
					// Display the message
					console.error(message);
					$A.getCallback(function () {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'Budget Line not created',
							type: 'ERROR',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					});
					$A.get('e.force:refreshView').fire();
				}
			});
			$A.enqueueAction(action);
		} else {
			// alert('hello');
			var action = component.get("c.createBudgetItemFromExpenseItem");
			action.setParams({
				"expenseDescription": expenseDescription,
				"expensebudgetId": expensebudget,
				"expenseType": expenseType,
				"expenseCostCode": expenseCostCode,
				"expensePaymentMethod": expensePaymentMethod,
				"expenseRefNo": expenseRefNo,
				"expenseAmount": expenseAmount,
				"expenseNote": expenseNote,
				"projectId": component.get("v.sampleNewRecord").buildertek__Project__c
			});
			action.setCallback(this, function (response) {
				if (response.getState() === "SUCCESS") {
					$A.get("e.c:BT_SpinnerEvent").setParams({
						"action": "HIDE"
					}).fire();
					$A.getCallback(function () {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'Budget Line created successfully',
							type: 'success',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					});
					$A.get('e.force:refreshView').fire();
					component.refreshData();
					component.set("v.expenseDescription", null);
					component.set("v.expensebudget", null);
					component.set("v.expenseType", null);
					component.set("v.expenseCostCode", null);
					component.set("v.expensePaymentMethod", null);
					component.set("v.expenseRefNo", null);
					component.set("v.expenseAmount", null);
					component.set("v.expenseNote", null);
                    component.set("v.budgetItemId", '');
				} else if (response.getState() === "ERROR") {
					let errors = response.getError();
					let message = 'Unknown error'; // Default error message
					// Retrieve the error message sent by the server
					if (errors && Array.isArray(errors) && errors.length > 0) {
						message = errors[0].message;
					}
					// Display the message
					console.error(message);
					$A.getCallback(function () {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							mode: 'sticky',
							message: 'Budget Line not created',
							type: 'ERROR',
							duration: '10000',
							mode: 'dismissible'
						});
						toastEvent.fire();
					});
					$A.get('e.force:refreshView').fire();
				}
			});
			$A.enqueueAction(action);
		}

	},*/
    getUOMValues : function(component, event, helper){
        var action = component.get("c.getProductUOM");
        var productId = component.get("v.productId"); 
        action.setParams({
            "productId": productId
        });
        action.setCallback(this, function (respo) {
            var res = respo.getReturnValue();
            var ProductDetails = component.get("v.newQuote");
            if (res != null) {
                var existuom = false;
                var quoteUOM =  component.get("v.options");
                for(var i= 0; i < quoteUOM.length; i++){
                    if(quoteUOM[i]. value == res){
                        existuom = true;
                        break;
                    }
                }
                if(existuom == true){
                    component.set("v.UOMvalues", res);
                }else{
                    component.set("v.UOMvalues", 'Each');
                }
            }else{
                component.set("v.UOMvalues", 'Each');
            } 
        });
        $A.enqueueAction(action);
        
    },
        
    fetchCORecordType: function (component, event, helper) {
        var actions = component.get("c.getCOCustomerRecordType");        
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();               
                component.set("v.COCustomerRecordType", result);
            }
        });
        $A.enqueueAction(actions);
    },
    fetchInvoiceRecordType: function (component, event, helper) {
        var actions = component.get("c.getInvoiceCustomerRecordType");        
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();               
                component.set("v.InvoiceCustomerRecordType", result);
            }
        });
        $A.enqueueAction(actions);
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
});