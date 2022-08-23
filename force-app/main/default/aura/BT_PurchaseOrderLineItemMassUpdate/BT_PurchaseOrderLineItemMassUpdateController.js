({
  doInit: function (component, event, helper) {
    component.set("v.isLoading", true);
    var pageNumber = component.get("v.PageNumber");
    var pageSize = component.get("v.pageSize");
    helper.getTableFieldSet(component, event, helper);

    window.setTimeout(
      $A.getCallback(function () {
        helper.getTotalRecord(component, event, helper);
        helper.getTableRows(component, event, helper, pageNumber, pageSize);
        component.set("v.isLoading", false);
      }),
      2000
    );
  },

  onAddClick: function (component, event, helper) {
    var fields = component.get("v.fieldSetValues");
    var list = component.get("v.listOfRecords");
    var obj = {};
    for (var i in fields) {
      obj[fields[i].name] = "";
      if (fields[i].type == "BOOLEAN") {
        obj[fields[i].name] = false;
      }
    }
    list.unshift(obj);
    component.set("v.listOfRecords", list);
  },

  onMassUpdate: function (component, event, helper) {
    component.set("v.isLoading", true);
    if (!component.get("v.massUpdateEnable")) {
      component.set("v.massUpdateEnable", true);
      component.set("v.isLoading", false);
    } else if (component.get("v.massUpdateEnable")) {
      component.set("v.isLoading", true);
      component.set("v.massUpdateEnable", false);
      helper.updateMassRecords(component, event, helper);
    }
  },

  onMassUpdateCancel: function (component, event, helper) {
    if (component.get("v.massUpdateEnable")) {
      component.set("v.isCancelModalOpen", true);
    }
  },

  closeScreen: function (component, event, helper) {
    console.log("Close Screen!");
    //component.set("v.isCancelModalOpen", false);
    // var appEvent = $A.get("e.c:ApplicationEvent");
    // appEvent.setParams({
    //   message: "Close Tab",
    // });
    // appEvent.fire();
    var myEvent = $A.get("e.c:myEvent");
        myEvent.setParams({"data":"Test"}); 
        myEvent.fire();
    //var redirectUrl = '/one/one.app?#/sObject/'+component.get('v.recordId')+'/view';
    //window.open(redirectUrl,'_self');
  },

  deleteRecord: function (component, event, helper) {
    var target = event.target;
    var index = target.getAttribute("data-index");
    var records = component.get("v.listOfRecords");
    if (records[index].Id != undefined) {
      component.set("v.selectedRecordIndex", index);
      component.set("v.quoteLineName", records[index].Name);
      component.set("v.isModalOpen", true);
    } else if (records[index].Id == undefined) {
      records.splice(index, 1);
      component.set("v.listOfRecords", records);
    }
  },

  handleCancel: function (component, event, helper) {
    component.set("v.isModalOpen", false);
  },

  closeCancelModal: function (component, event, helper) {
    component.set("v.isCancelModalOpen", false);
  },

  handleDelete: function (component, event, helper) {
    var records = component.get("v.listOfRecords");
    var index = component.get("v.selectedRecordIndex");
    if (records[index].Id != undefined) {
      component.set("v.listOfRecords", records);
      component.set("v.isModalOpen", false);
      helper.deleteRecord(component, event, helper, records[index].Id);
    }
  },

  handleNext: function (component, event, helper) {
    component.set("v.isLoading", true);
    var pageNumber = component.get("v.PageNumber");
    var pageSize = component.get("v.pageSize");
    pageNumber++;
    helper.getTableRows(component, event, helper, pageNumber, pageSize);
  },

  handlePrev: function (component, event, helper) {
    component.set("v.isLoading", true);
    var pageNumber = component.get("v.PageNumber");
    var pageSize = component.get("v.pageSize");
    pageNumber--;
    helper.getTableRows(component, event, helper, pageNumber, pageSize);
  },

  searchKeyChange: function (component, event, helper) {
    component.set("v.isLoading", true);
    var pageNumber = component.get("v.PageNumber");
    var pageSize = component.get("v.pageSize");
    helper.getTableRows(component, event, helper, pageNumber, pageSize);
    component.set("v.isLoading", false);
  },
});