public with sharing class NewPRLineDetails {
    @AuraEnabled
    public static String createPRLineDetails(buildertek__Pricing_Request_Line_Details__c PRLineDetails) {
        insert PRLineDetails;
        return PRLineDetails.Id;
    }
}