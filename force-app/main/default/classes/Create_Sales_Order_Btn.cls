public with sharing class Create_Sales_Order_Btn {
    @AuraEnabled
    public static string createSalesOrder(String recordId) {
        try {            
            
            buildertek__Quote__c quote = [SELECT Id, buildertek__Primary_Contact__c, buildertek__Primary_Contact__r.AccountId, buildertek__Primary_Contact__r.Email, buildertek__Project__c, buildertek__Notes__c FROM buildertek__Quote__c where Id=:recordId];
            
            System.debug('quote => '+quote);
            buildertek__Sales_Order__c salesOrder = new buildertek__Sales_Order__c();
            salesOrder.buildertek__Contact__c = quote.buildertek__Primary_Contact__c;
            salesOrder.buildertek__Project__c = quote.buildertek__Project__c;
            salesOrder.buildertek__Customer_Notes__c = quote.buildertek__Notes__c;
            salesOrder.buildertek__Quote__c = quote.Id;
            salesOrder.buildertek__Contact_Email__c = quote.buildertek__Primary_Contact__r.Email;
            salesOrder.buildertek__Account__c = quote.buildertek__Primary_Contact__r.AccountId;
            insert salesOrder;

            buildertek__Sales_Order_Lines__c orderLine = new buildertek__Sales_Order_Lines__c(); 
            orderLine.buildertek__Sales_Order__c = salesOrder.Id;
            insert orderLine;          
            
            return 'Success'; 

        } catch (Exception e) {
            System.debug('Error => '+e.getMessage());
            return 'Error';
        }
    }
}