declare module "@salesforce/apex/BudgetDAO.getcurrency" {
  export default function getcurrency(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getmulticurrency" {
  export default function getmulticurrency(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getBudgetLineRecords" {
  export default function getBudgetLineRecords(param: {selectedBudgetId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateBudgetItemFromExpenseItem" {
  export default function updateBudgetItemFromExpenseItem(param: {expenseNote: any, expenseAmount: any, expenseRefNo: any, expensePaymentMethod: any, expenseCostCode: any, expenseType: any, expensebudgetId: any, expenseDescription: any, projectId: any, budgetItemId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.createBudgetItemFromExpenseItem" {
  export default function createBudgetItemFromExpenseItem(param: {expenseNote: any, expenseAmount: any, expenseRefNo: any, expensePaymentMethod: any, expenseCostCode: any, expenseType: any, expensebudgetId: any, expenseDescription: any, projectId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.duplicateExpense" {
  export default function duplicateExpense(param: {expenseAmount: any, expenseType: any, expensePaymentMethod: any, expenseDescription: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getContingencyBudgetItems" {
  export default function getContingencyBudgetItems(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.transferAmount" {
  export default function transferAmount(param: {isLeftToRight: any, budgetId: any, budgetLineId: any, budgetAmount: any, contingencyId: any, contingencyAmount: any, amount: any, note: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.savenewbudgetlinegroup" {
  export default function savenewbudgetlinegroup(param: {newbudgetllinegroup: any, newbudgetllinegroupdes: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.saveNewBudgetSubGroup" {
  export default function saveNewBudgetSubGroup(param: {budgetLineSubGroupName: any, budgetLineSubGroupDescription: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.createBudgetItem" {
  export default function createBudgetItem(param: {budgetItemsJSON: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.createRFQFromBudget" {
  export default function createRFQFromBudget(param: {budget: any, rfqJson: any, rfqItemsJson: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.createPOFromBudget" {
  export default function createPOFromBudget(param: {budget: any, poJson: any, poItemsJson: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.createCOFromBudget" {
  export default function createCOFromBudget(param: {budget: any, coJson: any, coItemsJson: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getProductPrice" {
  export default function getProductPrice(param: {productId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.saveBudgetLineItem" {
  export default function saveBudgetLineItem(param: {budgetLineRecord: any, recordId: any, contractor: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.retrieveGroups" {
  export default function retrieveGroups(param: {budgetId: any, pageNumber: any, recordToDisply: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getFieldSet" {
  export default function getFieldSet(param: {fieldSetName: any, objectName: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateGroupsOrder" {
  export default function updateGroupsOrder(param: {groups: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.deleteGroups" {
  export default function deleteGroups(param: {groups: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.deleteBudgetItem" {
  export default function deleteBudgetItem(param: {budgetItems: any, groupId: any, budgetId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getBudgetItem" {
  export default function getBudgetItem(param: {budgetLineRecord: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateBudgetLineItem" {
  export default function updateBudgetLineItem(param: {budgetLineRecord: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getpricebook" {
  export default function getpricebook(param: {BudgetId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getselect" {
  export default function getselect(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getselectOptions" {
  export default function getselectOptions(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getselectOptionsforproductfamily" {
  export default function getselectOptionsforproductfamily(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getpricebooks" {
  export default function getpricebooks(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getProductfamilyRecords" {
  export default function getProductfamilyRecords(param: {ObjectName: any, parentId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.BudgetItemList" {
  export default function BudgetItemList(param: {BudgetIds: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.checkSchedulesRecords" {
  export default function checkSchedulesRecords(param: {projectId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.deleteLineItems" {
  export default function deleteLineItems(param: {budgetItemIds: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.deleteBudgetLineItem" {
  export default function deleteBudgetLineItem(param: {budgetId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.RemovegroupingBudgetLineItems" {
  export default function RemovegroupingBudgetLineItems(param: {groupingid: any, budgetId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.deleteSelectedItems" {
  export default function deleteSelectedItems(param: {recordIds: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.groupValues" {
  export default function groupValues(param: {recordId: any, currencyFields: any, allFields: any, groupIds: any, recordToDisply: any, offset: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getBudgetItemData" {
  export default function getBudgetItemData(param: {recordId: any, fieldsList: any, fieldString: any, recordToDisply: any, offset: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.prepareString" {
  export default function prepareString(param: {budgetString: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.saveUpdatedValues" {
  export default function saveUpdatedValues(param: {budgetItemList: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.massUpdateBudgetLineItem" {
  export default function massUpdateBudgetLineItem(param: {budgetLineRecords: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.massDuplicateBudgetLineItem" {
  export default function massDuplicateBudgetLineItem(param: {budgetLineRecords: any, recordid: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.fetchAccount" {
  export default function fetchAccount(param: {searchKeyWord: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getBudgetDetails" {
  export default function getBudgetDetails(param: {budgetRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.searchbudgetFilter" {
  export default function searchbudgetFilter(param: {recordList: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getBudgetData" {
  export default function getBudgetData(param: {pageNumber: any, pageSize: any, RecId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getTimeCardData" {
  export default function getTimeCardData(param: {pageNumber: any, pageSize: any, RecId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getInvioceData" {
  export default function getInvioceData(param: {pageNumber: any, pageSize: any, RecId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateLaborPrice" {
  export default function updateLaborPrice(param: {recordId: any, budgeLineIds: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateInvoicePrice" {
  export default function updateInvoicePrice(param: {recordId: any, budgeLineIds: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getbudget" {
  export default function getbudget(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getProductUOM" {
  export default function getProductUOM(param: {productId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getCOCustomerRecordType" {
  export default function getCOCustomerRecordType(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getInvoiceCustomerRecordType" {
  export default function getInvoiceCustomerRecordType(): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getRecords" {
  export default function getRecords(param: {parentRecordId: any, fieldNameJson: any, pageNumber: any, pageSize: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateRecords" {
  export default function updateRecords(param: {recordId: any, updatedRecords: any, fieldSetName: any, pageNumber: any, pageSize: any, deleteLineitems: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.updateMultipleBudgetLine" {
  export default function updateMultipleBudgetLine(param: {recordId: any, updatedRecords: any, fieldSetName: any, pageNumber: any, pageSize: any, deleteLineitems: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getProduct" {
  export default function getProduct(param: {coItems: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getCoData" {
  export default function getCoData(param: {RecId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getExpenseData" {
  export default function getExpenseData(param: {RecId: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.addCoToBudget" {
  export default function addCoToBudget(param: {budgeLineIds: any, selectedCO: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.addExpenseToBudget" {
  export default function addExpenseToBudget(param: {budgeLineIds: any, selectedExpense: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.addProductsToList" {
  export default function addProductsToList(param: {COItems: any, COItem: any, count: any}): Promise<any>;
}
declare module "@salesforce/apex/BudgetDAO.getadminvalues" {
  export default function getadminvalues(): Promise<any>;
}
