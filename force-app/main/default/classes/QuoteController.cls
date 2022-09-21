public with sharing class QuoteController {
    
  /*  @AuraEnabled    
    public static buildertek__Project__c getProjectDetails(Id get_accountid){
        buildertek__Project__c project;         
        project=[select Name,buildertek__Address__c,buildertek__City__c,buildertek__State__c,buildertek__Zip__c,buildertek__Country__c from buildertek__Project__c where id=:get_accountid];
        return project;         
    }
    
    @AuraEnabled
    public static buildertek__Service_Request__c getServiceReqDetails(String recordId){
         buildertek__Service_Request__c serviceReq ;         
            serviceReq = [Select Id, Name, buildertek__Project__c from buildertek__Service_Request__c where Id =: recordId]; 
        	return serviceReq;
    }
    
    @AuraEnabled
    public static quotebilladdresswrap getOpportunityDetails(String recordId){
        Opportunity opp ;        
        opp = [Select Id,Name,AccountId,Account.Name,Account.Billingcity,Account.Billingstate,Account.Billingcountry,Account.Billingstreet,Account.buildertek__Email_Address__c,Account.Phone,Account.Billingpostalcode from Opportunity where Id =: recordId limit 1]; 
        list<quotebilladdresswrap>  wraplst = new list<quotebilladdresswrap> ();
        quotebilladdresswrap wraprec = new quotebilladdresswrap();
        	wraprec.accemail = opp.Account.buildertek__Email_Address__c;
        	wraprec.accphone = opp.Account.Phone;
        	wraprec.OppName = opp.Name;
        	wraprec.BillingName = opp.Account.Name;
             wraprec.Billingcity = opp.Account.Billingcity;
             wraprec.Billingstate = opp.Account.Billingstate;
             wraprec.Billingcountry = opp.Account.Billingcountry;
             wraprec.Billingstreet = opp.Account.Billingstreet;
             wraprec.Billingpostalcode = opp.Account.Billingpostalcode;
     //  buildertek__Quote__c bt=new buildertek__Quote__c();
      //  bt.buildertek__Bill_To_Email_Address__c=opp.
        //  wraplst.add(wraprec);
        return wraprec;
      	//	insert wraprec;
    }
public class quotebilladdresswrap {
     @AuraEnabled
    public String accemail {get;set;}
    @AuraEnabled
    public String accphone {get;set;}
    @AuraEnabled
    public String OppName {get;set;}
    @AuraEnabled
    public String BillingName {get;set;}
    @AuraEnabled
    public String Billingcity {get;set;}
    @AuraEnabled
    public String Billingstate {get;set;}
    @AuraEnabled
    public String Billingcountry {get;set;}
    @AuraEnabled
    public String Billingstreet {get;set;}
    @AuraEnabled
    public String Billingpostalcode {get;set;}
 }*/
    
     @AuraEnabled
    public static string createQuote(String recordId) {
        try {
            Opportunity opp = [Select Id,Name,AccountId,Account.Name,Account.Billingcity,Account.Billingstate,Account.Billingcountry,Account.Billingstreet,Account.buildertek__Email_Address__c,Account.Phone,Account.Billingpostalcode from Opportunity where Id =: recordId limit 1]; 
            System.debug('Opportunity =>'+opp);
            ID oppId=opp.Id;
            buildertek__Quote__c qt=new buildertek__Quote__c();
            qt.buildertek__Opportunity__c=oppId;
            qt.Name=opp.Name;
            
            insert qt;
            return 'success';
        }catch (Exception e) {
            System.debug('Error => '+e.getMessage());
            return 'Error';
        }
    }
}