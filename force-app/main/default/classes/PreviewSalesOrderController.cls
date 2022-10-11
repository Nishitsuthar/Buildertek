public with sharing class PreviewSalesOrderController {

    @AuraEnabled
    public Static List<EmailTemplate> getTemplates(){
        List<Emailtemplate> tempList = [SELECT Id, Name, folder.name FROM Emailtemplate WHERE Name =:'Sales Order'];
        return tempList;
    }
}