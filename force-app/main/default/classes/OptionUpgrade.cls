public with sharing class OptionUpgrade {

    @AuraEnabled
    public static void getDetails(String recordId) {
        buildertek__Question__c option = [SELECT Id, Name, buildertek__Product__c, buildertek__Section__c FROM buildertek__Question__c WHERE Id =: recordId];

        if (option.buildertek__Section__c != null) {
            List<Product2> listName = [SELECT Id, Name FROM Product2 WHERE buildertek__Selection_Category_Lookup__c =: option.buildertek__Section__c];
        }
    }
}