({
    doInit : function(component, event, helper) {
        helper.initHelper(component, event, helper);
    }, 

    handleClick : function(component, event, helper){
        var idx = event.getSource().get("v.value");
        component.set("v.isModalOpen", true);
        var productList = component.get('v.productList');
        var productValue = productList[idx];
        if (productValue.PricebookEntries != null && productValue.PricebookEntries.length >0) {
            component.set("v.nullPricebook", false);
            component.set("v.pricebookList", productValue.PricebookEntries);
        } else{
            component.set("v.nullPricebook", true);
        }
    }, 
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.firstModal", true);
    },

    onNext: function(component, event, helper) {
        var pricebook = component.get("v.selectedPricebook");
        console.log('pricebook => '+pricebook);
        if (pricebook != undefined) {
            component.set("v.firstModal", false);
        } else {
            helper.showToast("Error", "Error", "Please Select Pricebook First", "5000");
        }
    },

    doSearch: function (component, event, helper) {
        helper.searchHelper(component, event, helper);
    },
    
    selectPriceBook: function (component, event, helper){
        var priceBookId = event.getSource().get("v.text");
        console.log('priceBookId ==> '+priceBookId);
        component.set("v.selectedPricebook", priceBookId);
    }, 

    onSave: function (component, event, helper){
        component.set("v.isModalOpen", false);
        component.set("v.firstModal", true);
    }, 

    onUpgrade: function (component, event, helper){
        component.set("v.isModalOpen", false);
    }, 

})