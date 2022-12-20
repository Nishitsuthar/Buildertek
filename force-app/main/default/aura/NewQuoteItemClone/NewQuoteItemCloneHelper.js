({
    getcurr: function(component, event, helper) {
        var action = component.get("c.getRfqTo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.currencycode", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    setRejectedBtnColor: function(component, event, helper) {
        console.log(component.get('v.recordId'));
        let statusIsRejected = false;
        var action = component.get('c.getQuoteLines');
        action.setParams({
            recordId: component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var result = response.getReturnValue();
            result.forEach(element => {
                if (result != null) {
                    // component.set('v.rejectData', result);
                    statusIsRejected = true;
                }

            });
            console.log(statusIsRejected);
            if (statusIsRejected) {
                var getBtn = component.find('rejectBtn');
                getBtn.set('v.variant', 'destructive');
                getBtn.set('v.disabled', false);

            } else {
                var getBtn = component.find('rejectBtn');
                getBtn.set('v.disabled', true);

            }
        });
        $A.enqueueAction(action);

    },

    getmulticur: function(component, event, helper) {
        var action = component.get("c.getmulticurrency");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.multicurrency", response.getReturnValue());
                //  component.set("v.multicurrency",false);
            }
        });
        $A.enqueueAction(action);
    },

    createProductItemPicker: function(component, event, helper, groupId) {

        var overlayLib;
        $A.createComponents([
                ["c:BT_ProductsAdder", {
                    "aura:id": "btSelectProducts",
                    "recordId": component.get("v.recordId"),
                    "_gFiled": "buildertek__Grouping__c",
                    "_gSobject": "buildertek__Quote_Item__c",
                    "_gFilter": "",
                    "saveCallback": function(Items) {
                        console.log('items', Items);
                        var newQuoteItems = [];
                        for (var i = 0; i < Items.length; i++) {
                            var newQi = new Object();
                            newQi.buildertek__Quote__c = component.get("v.recordId"),
                                newQi.buildertek__Grouping__c = Items[i].groupid;
                            newQi.buildertek__Product__c = Items[i].productId;
                            newQi.Name = Items[i].productName;
                            newQi.buildertek__budget__c = component.get("v.recordId");
                            newQi.buildertek__Unit_Price__c = Items[i].salesPrice;
                            newQi.buildertek__Unit_Cost__c = Items[i].salesPrice;
                            newQi.buildertek__quantity__c = Items[i].quantity;
                            newQi.buildertek__Additional_Discount__c = Items[i].Discount;
                            newQi.buildertek__Description__c = Items[i].description;
                            newQuoteItems.push(newQi);
                        }
                        overlayLib.close();
                        $A.get("e.c:BT_SpinnerEvent").setParams({
                            "action": "SHOW"
                        }).fire();
                        helper.addSelectedProducts(component, event, helper, newQuoteItems);
                    },
                    "cancelCallback": function() {
                        overlayLib.close();
                    }
                }],

            ],
            function(components, status, errorMessage) {

                if (status === "SUCCESS") {
                    component.find('overlayLib').showCustomModal({
                        header: "Add Product(s) in Quote",
                        body: components[0],
                        footer: "",
                        showCloseButton: true,
                        cssClass: "btmodal_80",
                        closeCallback: function() {

                        }
                    }).then(function(overlay) {
                        overlayLib = overlay;
                    });
                }
            }
        );

    },


    createQuoteLineGroup: function(component, event, helper) {
        var groupName = component.get('v.quoteGroupName');
        var quoteGroupNameDescription = component.get('v.quoteGroupNameDescription');
        var action = component.get("c.insertQuoteLineGroup");
        action.setParams({
            groupName: groupName,
            groupDescription: quoteGroupNameDescription
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if (result === 'Success') {
                    component.set('v.addGroupPopup', false);
                    component.set('v.quoteGroupNameDescription', '');
                    component.set('v.quoteGroupName', '');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": 'Group Created Successfully!'
                    });
                    toastEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": 'Something went wrong!'
                    });
                    toastEvent.fire();
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": 'Something went wrong!'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    addProductToGroup: function(component, event, helper) {
        /*  $A.get("e.c:BT_SpinnerEvent").setParams({
          "action": "SHOW"
          }).fire(); */
        //  component.set("v.Spinner", true);
        var quoteObject = component.get("v.newQuote");
        console.log("Quote 11")
        var recordId = component.get("v.recordId");
        component.set("v.newQuote.buildertek__Quote__c", recordId);
        console.log("Quote 12")
        var markup = quoteObject.buildertek__Markup__c;
        var uom = component.get("v.UOMvalues");
        var QuoteLine = quoteObject.Name;
        var Unitcost = quoteObject.buildertek__Unit_Cost__c;
        // alert(QuoteLine);
        if (QuoteLine == null || QuoteLine == '' || QuoteLine == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please Provide a Quote Line Description.',
                duration: ' 1000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();
            // component.set("v.Spinner", false);
        } else if (Unitcost == null || Unitcost == '' || Unitcost == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please Provide a Unit Cost.',
                duration: ' 1000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();

        } else {


            //alert('hii'+);
            // alert(component.find('uomId').get("v.value"));
            //markup = markup * 100;
            // var uom = component.find('uomId').get("v.value");
            console.log("Quote 13")
            component.set("v.newQuote.buildertek__Markup__c", markup);
            console.log("Quote 14")
            component.set("v.newQuote.buildertek__UOM__c", uom);

            //   alert(component.get("v.newQuote.buildertek__UOM__c"));
            quoteObject.buildertek__Grouping__c = quoteObject.buildertek__Grouping__c == undefined ? component.get('v.quoteGroupId') : quoteObject.buildertek__Grouping__c;

            var action = component.get("c.saveQuoteLineItem");
            action.setParams({
                "quoteLineRecord": JSON.stringify(quoteObject)
            });

            action.setCallback(this, function(respo) {
                if (component.isValid() && respo.getState() === "SUCCESS") {
                    component.set('v.isAddProductFromGroup', false);
                    var group = component.find('groupId');
                    group.set("v._text_value", '');
                    var product = component.get('v.selectedLookUpRecord');
                    var compEvent = $A.get('e.c:BT_CLearLightningLookupEvent');
                    compEvent.setParams({
                        "recordByEvent": product
                    });
                    compEvent.fire();
                    component.set('v.isAddProductFromGroup', false);
                    console.log("Quote 15")
                    component.set('v.newQuote.Name', '');
                    component.set('v.newQuote.buildertek__Grouping__c', null);
                    component.set('v.newQuote.buildertek__UOM__c', '');
                    component.set('v.newQuote.buildertek__Unit_Cost__c', '');
                    component.set('v.newQuote.buildertek__Quantity__c', 1);
                    component.set('v.newQuote.buildertek__Markup__c', '');
                    component.set('v.newQuote.buildertek__Unit_Price__c', '');
                    component.set('v.newQuote.buildertek__Product__c', '');
                    component.set("v.listofproductfamily", '');
                    $A.get('e.force:refreshView').fire();
                    window.setTimeout(
                        $A.getCallback(function() {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                mode: 'sticky',
                                message: 'Quote Line created successfully',
                                type: 'success',
                                duration: '1000',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();
                        }), 1000
                    );
                    component.set('v.isAddProductFromGroup', false);
                    var page = component.get("v.page") || 1
                    helper.getGroups(component, event, helper, page);
                    helper.fetchpricebooks(component, event, helper);
                    helper.fetchPickListVal(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        }

    },

    addAndSaveProduct: function(component, event, helper) {
        $A.get("e.c:BT_SpinnerEvent").setParams({
            "action": "SHOW"
        }).fire();
        console.log("Quote 16")
        var quoteObject = component.get("v.newQuote");
        var recordId = component.get("v.recordId");
        component.set("v.newQuote.buildertek__Quote__c", recordId);
        var markup = quoteObject.buildertek__Markup__c;
        var uom = component.get("v.UOMvalues");
        console.log("Quote 17")
        component.set("v.newQuote.buildertek__Markup__c", markup);
        component.set("v.newQuote.buildertek__UOM__c", uom);
        quoteObject.buildertek__Grouping__c = quoteObject.buildertek__Grouping__c == undefined ? component.get('v.quoteGroupId') : quoteObject.buildertek__Grouping__c;
        var action = component.get("c.saveQuoteLineItem");
        action.setParams({
            "quoteLineRecord": JSON.stringify(quoteObject)
        });
        action.setCallback(this, function(respo) {
            if (component.isValid() && respo.getState() === "SUCCESS") {
                var group = component.find('groupId');
                group.set("v._text_value", '');
                var product = component.get('v.selectedLookUpRecord');
                var compEvent = $A.get('e.c:BT_CLearLightningLookupEvent');
                compEvent.setParams({
                    "recordByEvent": product
                });
                compEvent.fire();
                //alert('v.newQuote.Name'+component.get('v.newQuote.Name'));
                //alert('v.newQuote.Name'+component.get('v.newQuote.buildertek__Unit_Cost__c'));
                component.set('v.newQuote.Name', '');
                console.log("Quote 18")
                    //component.set('v.newQuote.Name', component.get('v.newQuote.Name'));
                component.set('v.newQuote.buildertek__Grouping__c', null);
                component.set('v.newQuote.buildertek__UOM__c', '');
                component.set('v.newQuote.buildertek__Unit_Cost__c', '');
                //component.set('v.newQuote.buildertek__Unit_Cost__c', component.get('v.newQuote.buildertek__Unit_Cost__c'));
                component.set('v.newQuote.buildertek__Quantity__c', 1);
                component.set('v.newQuote.buildertek__Markup__c', '');
                component.set("v.listofproductfamily", '');

                component.set("v.Spinner", false);
                window.setTimeout(
                    $A.getCallback(function() {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: 'sticky',
                            message: 'Quote Line created successfully',
                            type: 'success',
                            duration: '5000',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                        component.set('v.isAddProductFromGroup', false);
                    }), 1000
                );

                window.setTimeout(
                    $A.getCallback(function() {
                        component.set('v.isAddProductFromGroup', true);
                    }), 3000
                );


                //  component.set('v.isAddProductFromGroup', true);
                var page = component.get("v.page") || 1
                helper.getGroups(component, event, helper, page);
                helper.fetchpricebooks(component, event, helper);
                helper.fetchPickListVal(component, event, helper);

            }
        });
        $A.enqueueAction(action);
    },

    updateGroupDescription: function(component, event, helper) {
        var totalRecords = component.get('v.TotalRecords');
        var index = component.get('v.groupDescriptionIndex');
        var action = component.get("c.updateDescription");
        action.setParams({
            groupId: component.get('v.budgetGroupId'),
            groupDescription: component.get('v.groupDescription')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                component.set('v.isGroupDescriptionOpen', false);
                if (response.getReturnValue() == 'Success') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group Description Updated Successfully!',
                        type: 'success',
                        duration: '10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    if (totalRecords.groups[index].Id == component.get('v.budgetGroupId')) {
                        totalRecords.groups[index].buildertek__Description__c = component.get('v.groupDescription');
                        component.set('v.TotalRecords', totalRecords);
                    }
                } else if (response.getReturnValue() == 'Error') {

                }
            }
        });
        $A.enqueueAction(action);
    },

    updateName: function(component, event, helper) {
        var totalRecords = component.get('v.TotalRecords');
        var index = component.get('v.groupNameIndex');
        var action = component.get("c.updateGroupName");
        action.setParams({
            groupId: component.get('v.changeGroupNameId'),
            groupName: component.get('v.changeGroupName')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                if (response.getReturnValue() == 'Success') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group Name Updated Successfully!',
                        type: 'success',
                        duration: '10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    if (totalRecords.groups[index].Id == component.get('v.changeGroupNameId')) {
                        totalRecords.groups[index].Name = component.get('v.changeGroupName');
                        component.set('v.TotalRecords', totalRecords);
                    }
                    component.set('v.isGroupNameOpen', false);
                } else if (response.getReturnValue() == 'Warning') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group Name Already Exist!',
                        type: 'warning',
                        duration: '10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                } else if (response.getReturnValue() == 'Error') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Something went wrong!',
                        type: 'error',
                        duration: '10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    message: 'Something went wrong!',
                    type: 'error',
                    duration: '10000',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    insertGroup: function(component, event, helper) {
        var action = component.get("c.insertGroupName");
        action.setParams({
            groupName: component.get('v.changeGroupName')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                if (response.getReturnValue() == 'Success') {
                    component.set('v.isGroupNameOpen', false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group Created Successfully!',
                        type: 'success',
                        duration: '10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    component.set('v.newQuote.Name', '');
                    component.set('v.newQuote.buildertek__Grouping__c', null);
                    component.set('v.newQuote.buildertek__UOM__c', '');
                    component.set('v.newQuote.buildertek__Unit_Cost__c', '');
                    component.set('v.newQuote.buildertek__Quantity__c', 1);
                    component.set('v.newQuote.buildertek__Markup__c', '');
                    component.set("v.listofproductfamily", '');
                    $A.get('e.force:refreshView').fire();
                    var page = component.get("v.page") || 1
                    helper.getGroups(component, event, helper, page);
                } else if (response.getReturnValue() == 'Warning') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group Already Exist!',
                        type: 'warning',
                        duration: '10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    createRFQPicker: function(component, event, helper) {
        var overlayLib;
        $A.createComponents([
                ["c:BT_RFQSelection", {
                    "aura:id": "btSelectRFQ",
                    "projectId": "",
                    "quotId": component.get("v.recordId"),
                    "saveCallback": function(Items) {
                        //console.log(Items);
                        $A.get("e.c:BT_SpinnerEvent").setParams({
                            "action": "SHOW"
                        }).fire();
                        overlayLib.close();
                        var action = component.get("c.createQuoteItem");
                        action.setParams({
                            quoteItemsJSON: JSON.stringify(Items)
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                /*var grid = component.find('quoteItemList');
                                grid.refreshData();*/
                                window.setTimeout(
                                    $A.getCallback(function() {
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            mode: 'sticky',
                                            message: 'Quote line added successfully',
                                            type: 'success',
                                            duration: '10000',
                                            mode: 'dismissible'
                                        });
                                        toastEvent.fire();
                                    }), 3000
                                );
                                component.refreshComponent();
                            } else if (state === "INCOMPLETE") {
                                // do something
                            } else if (state === "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        //console.log("Error message: " + errors[0].message);
                                    }
                                } else {
                                    //console.log("Unknown error");
                                }
                            }
                        });
                        $A.enqueueAction(action);
                    },
                    "cancelCallback": function() {
                        overlayLib.close();
                    }
                }],

            ],
            function(components, status, errorMessage) {
                if (status === "SUCCESS") {
                    component.find('overlayLib').showCustomModal({
                        header: "Select RFQ's",
                        body: components[0],
                        footer: components[0].find("footer"),
                        showCloseButton: true,
                        cssClass: "btmodal_60",
                        closeCallback: function() {

                        }
                    }).then(function(overlay) {
                        overlayLib = overlay;
                    });
                }
            }
        );

    },

    createForceRecordEditComp: function(component, event, helper, recordId, action, title, obj) {
        $A.createComponent("c:BT_Force_Record_Edit", {
                "aura:id": "btNewQuoteItemEdit",
                "title": title,
                "objectApi": "buildertek__Quote_Item__c",
                "parentId": component.get("v.recordId"),
                "parentApi": "buildertek__Quote__c",
                "newRecordName": "Quote Item",
                "saveCallBack": component.get("v.refreshGridAction"),
                "newRecordId": recordId,
                "defaultValue": obj,
                "action": action
            },
            function(grid) {
                if (component.isValid()) {
                    var targetCmp = component.find('newQuoteItem');
                    var body = targetCmp.get("v.body");
                    body.push(grid);
                    targetCmp.set("v.body", body);
                }
            }
        );
    },

    addSelectedProducts: function(component, event, helper, items) {
        var action;
        action = component.get("c.createQuoteItem");
        action.setParams({
            quoteItemsJSON: JSON.stringify(items)
        });
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                window.setTimeout(
                    $A.getCallback(function() {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "",
                            "message": "Product Added Successfully.",
                            "type": "success"
                        });
                        toastEvent.fire();
                    }), 3000
                );

                component.refreshComponent();
                //$A.get("e.c:BT_SpinnerEvent").setParams({"action" : "HIDE" }).fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": response.getError()[0].message
                });
                toastEvent.fire();
            }
        });
        //$A.get("e.c:BT_SpinnerEvent").setParams({"action" : "SHOW" }).fire();
        $A.enqueueAction(action);
    },
    // get an Price from 
    /* getProductDetails:function(component,event,helper){
        var action = component.get("c.getProductPrice");
        var productId = component.get("v.productId");
        var productName = component.get("v.productName");
        //console.log("----productId",productId);
        action.setParams({"productId":productId});
        action.setCallback(this,function(respo){
            var res = respo.getReturnValue(); 
            //console.log("----respo---",res.length);
            var getProductDetails = component.get("v.newQuote");
            delete getProductDetails.buildertek__Grouping__r;
            //console.log("@quote@",component.get("v.recordId"));
            getProductDetails.buildertek__Quote__c = component.get("v.recordId");
            //console.log("getprodct----",JSON.stringify(getProductDetails));
            if(res.length>=1) {
                getProductDetails.buildertek__Unit_Cost__c = res[0].UnitPrice;
            }else{
                getProductDetails.buildertek__Unit_Cost__c = 0;
            }
            getProductDetails.buildertek__Product__c = productId;
            
            getProductDetails.Name = productName;
            component.set("v.newQuote",getProductDetails);
            
            //console.log("getprodct----",JSON.stringify(getProductDetails));
			
            //console.log("----log",res);
        });
        $A.enqueueAction(action);
    },*/

    // Convert JSON object to sObject List

    getGroups: function(component, event, helper, page) {

        //component.set("v.groupLoaded", false);
        var quoteId = component.get("v.quoteId");
        if (quoteId) {
            if (component.find('expandCollapeseAllBtn2')) {
                if (component.find('expandCollapeseAllBtn2').get('v.iconName')) {
                    // var quoteId =  component.get("v.quoteId");
                    var spanEle = document.getElementsByClassName('expandAllBtn_' + quoteId);
                    if (spanEle[0]) {
                        spanEle[0].style.display = "none";
                    }
                    if (document.getElementsByClassName('CollapeseAllBtn_' + quoteId)[0]) {
                        document.getElementsByClassName('CollapeseAllBtn_' + quoteId)[0].style.display = "inline-block";
                    }
                    console.log(spanEle[0])
                }
            }
        }
        if (component.get("v.recordId")) {
            let checkBtnClick = component.get('v.clickRejectBtn');
            let status;
            var getBtn = component.find('rejectBtn');

            if (checkBtnClick) {
                status = 'Reject';

            } else {
                status = 'Accept';
            }
            console.log({ status });

            var action = component.get("c.retrieveGroups");
            action.setStorable({
                ignoreExisting: true
            });
            action.setParams({
                quoteId: component.get("v.recordId"),
                pageNumber: page,
                recordToDisply: 50,
                status: status
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(response.groups);
                    console.log('TotalRecords ==> ',{ result });
                    console.log(result.status);
                    // console.log(result.tarTable.ListOfEachRecord);


                    // if (response.groups == undefined) {

                    // }

                    component.set("v.TotalRecords", result); //This Line has slow performance past 200 objects being loaded.
                    if (result != undefined && result.wrapperList != undefined) {
                        component.set('v.wrapperListLength', result.wrapperList.length - 1);


                    }
                    if (result.groups != undefined) {
                        for (var i in result.groups) {
                            result.groups[i].isSelected = false;
                        }
                        // getBtn.set('v.variant', 'destructive');
                        // getBtn.set('v.disabled', false);
                        // getBtn.set('v.disabled', true);
                    }
                    component.set("v.columns", result.columns);
                    component.set("v.page", result.page);
                    component.set("v.total", result.total);

                    if (result.total == 0) {
                        component.set("v.pages", 1);
                    } else {
                        component.set("v.pages", Math.ceil(result.total / 50));
                    }
                    $A.get("e.c:BT_SpinnerEvent").setParams({
                        "action": "HIDE"
                    }).fire();
                }
            });
            $A.enqueueAction(action);
        }
    },

    /*updateMarkupOnUI : function(component, event, helper, page) {
        //alert('Hii');
		//component.set("v.groupLoaded", false);
		
        if(component.get("v.recordId")) {
            var action = component.get("c.retrieveGroups");
            action.setStorable({
                ignoreExisting: true
            });
            action.setParams({ 
                quoteId : component.get("v.recordId"),
                pageNumber : page,
                recordToDisply : 50
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue(); 
                    //alert('result -----> '+JSON.stringify(result));
                    //var t0 = performance.now();
                    component.set("v.TotalRecords", result);//This Line has slow performance past 200 objects being loaded.
                    console.log('total records....'+JSON.stringify(component.get("v.TotalRecords")));
                    //var t1 = performance.now();
                    //console.log("------------> component.set took " + (t1 - t0) + " milliseconds to execute."); 
                    component.set("v.columns", result.columns);
                    component.set("v.page", result.page);
                    component.set("v.total", result.total);
                    component.set("v.pages", Math.ceil(result.total / 50));
                    //component.set("v.Spinner", false); 
                    
                    $A.get("e.c:BT_SpinnerEvent").setParams({"action" : "HIDE" }).fire();
					
					window.setTimeout(
                        $A.getCallback(function() {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                mode: 'sticky',
                                message: 'Quote line markup(%) updated successfully.',
                                type : 'success',
                                duration: '10000', 
                                mode: 'dismissible'
                            });
                            toastEvent.fire();
                        }), 3000
                    );
                }
            });
            $A.enqueueAction(action);
        }
	},*/

    // get an Price from 
    getProductDetails: function(component, event, helper) {
        var action = component.get("c.getProductPrice");
        var productId = component.get("v.productId");
        var productName = component.get("v.productName");
        action.setParams({
            "productId": productId
        });
        action.setCallback(this, function(respo) {
            var res = respo.getReturnValue();
            console.log(JSON.stringify(res))
            var ProductDetails = component.get("v.newQuote");
            delete ProductDetails.buildertek__Grouping__r;
            ProductDetails.buildertek__Quote__c = component.get("v.recordId");
            if (res.length >= 1) {
                if (res[0].UnitPrice >= res[0].buildertek__Unit_Cost__c) {
                    var diffVal = res[0].UnitPrice - res[0].buildertek__Unit_Cost__c;
                    console.log("Diff Value : " + diffVal)
                    var mark = (diffVal / res[0].buildertek__Unit_Cost__c);

                    //ProductDetails.buildertek__Markup__c = (diffVal/res[0].buildertek__Unit_Cost__c) * 100;
                    if (mark != 'Infinity') {
                        //  ProductDetails.buildertek__Markup__c = (diffVal/res[0].buildertek__Unit_Cost__c).toFixed(2); 
                        ProductDetails.buildertek__Markup__c = res[0].buildertek__Markup__c;
                        console.log(ProductDetails.buildertek__Markup__c)
                    } else {
                        ProductDetails.buildertek__Markup__c = 0;
                    }

                } else {
                    ProductDetails.buildertek__Markup__c = 0;
                }
                ProductDetails.buildertek__Unit_Cost__c = res[0].buildertek__Unit_Cost__c;
                ProductDetails.buildertek__Unit_Price__c = res[0].UnitPrice;
                // ProductDetails.buildertek__Markup__c = res[0].buildertek__Markup__c / 100;
                /* ProductDetails.buildertek__Markup__c = res[0].buildertek__Unit_Cost__c / res[0].UnitPrice;
                ProductDetails.buildertek__Additional_Discount__c = res[0].buildertek__Discount__c;*/
                // component.set("v.UOMvalues", res[0].QuantityUnitOfMeasure);
                // alert('hii'+component.get("v.UOMvalues"));
                // ProductDetails.buildertek__UOM__c = res[0].QuantityUnitOfMeasure;

            } else {
                ProductDetails.buildertek__Unit_Cost__c = 0;
                ProductDetails.buildertek__Unit_Price__c = 0;
                ProductDetails.buildertek__Markup__c = 0;
                ProductDetails.buildertek__Additional_Discount__c = 0;
            }
            ProductDetails.buildertek__Product__c = productId;
            ProductDetails.Name = productName;

            console.log("Quote 21")
            component.set("v.newQuote", ProductDetails);
        });
        $A.enqueueAction(action);
    },
    getUOMValues: function(component, event, helper) {
        var action = component.get("c.getProductUOM");
        var productId = component.get("v.productId");
        action.setParams({
            "productId": productId
        });
        action.setCallback(this, function(respo) {
            var res = respo.getReturnValue();

            console.log("Quote 22")
            var ProductDetails = component.get("v.newQuote");
            if (res != null) {
                var existuom = false;
                var quoteUOM = component.get("v.options");
                for (var i = 0; i < quoteUOM.length; i++) {
                    if (quoteUOM[i].value == res) {
                        existuom = true;
                        break;
                    }
                }
                if (existuom == true) {
                    component.set("v.UOMvalues", res);
                } else {
                    component.set("v.UOMvalues", 'Each');
                }
            } else {
                component.set("v.UOMvalues", 'Each');
            }
        });
        $A.enqueueAction(action);

    },
    fetchPickListVal: function(component, event, helper) {
        var actions = component.get("c.getselectOptions");
        actions.setParams({
            "QuoteObject": component.get("v.newQuote"),
            "QuoteField": "buildertek__UOM__c"
        });
        var opts = [];
        actions.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allBudgetValues = JSON.parse(response.getReturnValue());
                if (allBudgetValues != undefined && allBudgetValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allBudgetValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allBudgetValues[i].Id,
                        value: allBudgetValues[i].Id
                    });

                }
                //component.find(elementId).set("v.options", opts);
                component.set("v.options", opts);
            }
        });
        $A.enqueueAction(actions);
    },

    /*getGrouping : function(component, event, fieldsList, allFields, groupIds){
        var recordId = component.get("v.recordId");
        //alert('recordId ---------> '+recordId);
        var action = component.get("c.groupValues");
        action.setParams({
            "recordId" : recordId,
            "currencyFields" : fieldsList,
            "allFields" : allFields,
            "groupIds" : groupIds
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('state -------->'+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                //console.log('result --------> '+JSON.stringify(result));
                component.set("v.InnerList", result);
                $A.get("e.c:BT_SpinnerEvent").setParams({"action" : "HIDE" }).fire();
            }
        });
        $A.enqueueAction(action);        
    },
    
    getTableData : function(component, event, allFields, fieldType){
        var recordId = component.get("v.recordId");
        allFields.push('Id','buildertek__Grouping__c');
        fieldType.push({"fieldName":'Id', "fieldType":'', "isEditable": false});
        fieldType.push({"fieldName":'buildertek__Grouping__c', "fieldType":'Reference', "isEditable": false});
        var finalString = JSON.stringify(fieldType)
        var action = component.get("c.getQuoteItemData"); 
        action.setParams({
            "recordId" : recordId,
            "fieldsList" : allFields,
            "fieldString" : finalString
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('state -------> '+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                //console.log('Final result --------> '+JSON.stringify(result));
                component.set("v.Table_header_Records", result);
            }
        });
        $A.enqueueAction(action);
    },*/

    fetchpricebooks: function(component, event, helper) {
        var action = component.get("c.getpricebook");
        action.setParams({
            "quoteId": component.get("v.recordId")
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {

                component.set("v.pricebookName", response.getReturnValue());
                /*Code Added */
                var group = component.find('groupId');
                group.set("v._text_value", '');
                var product = component.get('v.selectedLookUpRecord');
                var compEvent = $A.get('e.c:BT_CLearLightningLookupEvent');
                compEvent.setParams({
                    "recordByEvent": product
                });
                compEvent.fire();
                console.log("Quote 8")
                component.set('v.newQuote.Name', '');
                //component.set('v.newQuote.buildertek__Grouping__c', null);
                component.set('v.newQuote.buildertek__UOM__c', '');
                component.set('v.newQuote.buildertek__Unit_Cost__c', '');
                component.set('v.newQuote.buildertek__Unit_Price__c', null);
                component.set('v.newQuote.buildertek__Quantity__c', 1);
                component.set('v.newQuote.buildertek__Markup__c', '');
                component.set('v.newQuote.buildertek__Product__c', '');
                var pribooknames = component.get("v.pricebookName");
                console.log("PriceBook Name : ======= : ", pribooknames)
                    //alert(pribooknames)
                var action20 = component.get("c.getProductfamilyRecords");
                // set param to method  
                action20.setParams({
                    'ObjectName': "Product2",
                    'parentId': component.get("v.pricebookName")
                });
                // set a callBack    
                action20.setCallback(this, function(response) {
                    $A.util.removeClass(component.find("mySpinner"), "slds-show");
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        helper.fetchPickListVal(component, event, helper);
                        var storeResponse = response.getReturnValue();
                        // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                        if (storeResponse.length == 0) {
                            component.set("v.Message", 'No Result Found...');
                        } else {
                            component.set("v.Message", '');
                        }
                        // set searchResult list with return value from server.
                        component.set("v.listofproductfamily", storeResponse);

                        if (component.get("v.listofproductfamily").length > 0) {
                            component.set("v.productfamily", component.get("v.listofproductfamily")[0].productfamilyvalues);
                        } else {
                            component.set("v.productfamily", null)
                        }

                    }

                });
                // enqueue the Action  
                $A.enqueueAction(action20);
                /* Code closed */
            }
        });
        $A.enqueueAction(action);
        var actions = component.get("c.getpricebooks");

        var opts = [];
        actions.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                var opts = [];
                opts.push({
                    key: "None",
                    value: ""
                });
                for (var key in result) {
                    opts.push({
                        key: key,
                        value: result[key]
                    });
                }
                component.set("v.pricebookoptions", opts);
            }
        });
        $A.enqueueAction(actions);
    },

    getQuoteInfo: function(component, event, helper) {
        var actions = component.get("c.getQuoteRecord");
        actions.setParams({
            "quoteRecId": component.get("v.recordId")
        });
        actions.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.QuoteRec", result);
            }
        });
        $A.enqueueAction(actions);
    },

    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.data1");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse));
        data.sort(this.compare);
        component.set("v.data1", data);
        console.log("sorted data : ", component.get("v.data1"));
    },
    /* sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    } */

    sortBy: function(field, reverse, primer) {

        var key = primer ?
            function(x) { return primer(x.hasOwnProperty(field) ? (typeof x[field] === 'string' ? x[field].toLowerCase() : x[field]) : 'aaa') } :
            function(x) { return x.hasOwnProperty(field) ? (typeof x[field] === 'string' ? x[field].toLowerCase() : x[field]) : 'aaa' };
        reverse = !reverse ? 1 : -1;
        return function(a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },

    compare: function(a, b) {

        if (a.Family === null || a.Family == '' || a.Family == undefined) {
            return 1;
        }
        if (b.Family === null || b.Family == '' || b.Family == undefined) {
            return -1;
        }

        if (a.Family === b.Family) {
            return 0;
        }

        if (a.Family < b.Family) {
            return -1;
        }
        if (a.Family > b.Family) {
            return 1;
        }
        return 0;
    }

})