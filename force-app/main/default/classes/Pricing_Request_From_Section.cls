public with sharing class Pricing_Request_From_Section {

    @AuraEnabled
    public static List<buildertek__Question_Group__c> getRecord(String recordId) {
        List<buildertek__Question_Group__c> sectionList = [SELECT Id, Name, buildertek__Title__c, buildertek__Status__c, buildertek__Section__r.buildertek__Selection__r.buildertek__Project__c, (SELECT Id, Name FROM buildertek__Questions__r) FROM buildertek__Question_Group__c WHERE buildertek__Section__c =: recordId];
        System.debug('optionList => '+sectionList);
        return sectionList;
    }

    @AuraEnabled
    public static string createPR(String recordId, buildertek__Pricing_Request__c pricingRequest, List<buildertek__Question_Group__c> selectionTypeList, List<buildertek__Question__c> optionList){

        pricingRequest.buildertek__Status__c = 'Pending';
        pricingRequest.buildertek__Project__c = selectionTypeList[0].buildertek__Section__r.buildertek__Selection__r.buildertek__Project__c;
        insert pricingRequest;

        Map<Id, buildertek__Pricing_Request_Line__c> prLineMap = new Map<Id, buildertek__Pricing_Request_Line__c>();
        for (buildertek__Question_Group__c selectionType : selectionTypeList) {
            buildertek__Pricing_Request_Line__c prLine = new buildertek__Pricing_Request_Line__c();
            prLine.buildertek__Description__c = selectionType.Name;
            prLine.buildertek__Pricing_Request__c = pricingRequest.Id;
            prLineMap.put(selectionType.Id, prLine);
        }
        insert prLineMap.values();

        List<buildertek__Pricing_Request_Line_Details__c> prDetailsList = new List<buildertek__Pricing_Request_Line_Details__c>();
        for (buildertek__Question__c option : optionList) {
            buildertek__Pricing_Request_Line_Details__c prDetail = new buildertek__Pricing_Request_Line_Details__c();
            prDetail.buildertek__Description__c = option.Name;
            prDetail.buildertek__Pricing_Request_Line__c = prLineMap.get(option.buildertek__Question_Group__c).Id;
            prDetailsList.add(prDetail);
        }
        insert prDetailsList;

        return pricingRequest.Id;
    }
}