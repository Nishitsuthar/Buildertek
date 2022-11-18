@isTest
public with sharing class PreQualObject_MSAFormControllerTest {
    @TestSetup
    static void MSAForm() {
        buildertek__MSA_Settings__c ms =  new buildertek__MSA_Settings__c();
        ms.Name = 'MSA Settings';
        insert ms;
    }
    @isTest
    static void MSAForm2(){
        buildertek__MSA_Settings__c ms = new buildertek__MSA_Settings__c();
        ms=[select id,Name from buildertek__MSA_Settings__c WHERE Name = :'MSA Settings'];
        
        PreQualObject_MSAFormController.getMSASettings(ms.Id,'abc');
    }
}