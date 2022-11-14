public class createRFQClass {
	 @AuraEnabled
    public static String RFQList(buildertek__RFQ__c cOrder , String optionId){
        buildertek__RFQ__c rf=new buildertek__RFQ__c();
        buildertek__Question__c op=new buildertek__Question__c();
        op=[select id, Name from buildertek__Question__c];
        
        return 't';
    }
}