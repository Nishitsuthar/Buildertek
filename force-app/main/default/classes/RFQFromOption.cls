public with sharing class RFQFromOption {
    @AuraEnabled
    public static String RFQFrom_Option(buildertek__RFQ__c rfq, String optionId) {
        System.debug('Start-----------');        

        buildertek__Question__c optionList = new buildertek__Question__c();
        optionList = [SELECT Id , Name, buildertek__Manufacturer__c,buildertek__RFQ_Line__c, buildertek__Question_Group__r.buildertek__Section__r.buildertek__Selection__r.buildertek__Project__c FROM buildertek__Question__c WHERE Id =: optionId];
        System.debug('optionList.buildertek__Manufacturer__c------>'+optionList.buildertek__Manufacturer__c);

        rfq.buildertek__Project__c = optionList.buildertek__Question_Group__r.buildertek__Section__r.buildertek__Selection__r.buildertek__Project__c;
        System.debug('Project----->'+rfq.buildertek__Project__c);
        insert rfq;

        buildertek__RFQ_Item__c rfItemMap = new buildertek__RFQ_Item__c();
        rfItemMap.name = optionList.Name;
        System.debug('name--->'+rfItemMap.name);
        rfItemMap.buildertek__Vendor__c = optionList.buildertek__Manufacturer__c;
        System.debug('rfItemMap.buildertek__Vendor__c----------------------->'+rfItemMap.buildertek__Vendor__c);
        insert rfItemMap;

        return rfItemMap.Id;

    }
}