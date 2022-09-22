public with sharing class QuoteController {
     @AuraEnabled
    public static string createQuote(String recordId) {
        
        try {
            Opportunity opp = [Select Id,
                               		  Name,
                               		  AccountId,
                               		  Account.Name,
                               		  Account.Billingcity,
                               		  Account.Billingstate,
                               		  Account.Billingcountry,
                               		  Account.Billingstreet,
                               		  Account.buildertek__Email_Address__c,
                               		  Account.Phone,
                               		  Account.Billingpostalcode from Opportunity where Id =: recordId limit 1]; 
            System.debug('Opportunity =>'+opp);
            ID oppId=opp.Id;
            buildertek__Quote__c quoteRecord=new buildertek__Quote__c();
            quoteRecord.buildertek__Opportunity__c=oppId;
            quoteRecord.Name=opp.Name;    
            quoteRecord.buildertek__Bill_To_Email_Address__c=opp.Account.buildertek__Email_Address__c;
            quoteRecord.buildertek__Bill_To_Cell_Phone__c=opp.Account.Phone;
            quoteRecord.buildertek__Bill_To_Name__c=opp.Account.Name;
            quoteRecord.buildertek__Bill_To_City__c= opp.Account.Billingcity;
            quoteRecord.buildertek__Bill_To_Street__c=opp.Account.Billingstreet;
            quoteRecord.buildertek__Bill_To_Zip_Code__c=opp.Account.Billingpostalcode;
            //quoteRecord.buildertek__Bill_To_Country__c=opp.Account.Billingcountry;
            //quoteRecord.buildertek__Bill_To_State__c=opp.Account.Billingstate;         
            
            insert quoteRecord;
            return 'Success';
        }catch (Exception e) {
            System.debug('Error => '+e.getMessage());
            return 'Error';
        }
    }
}