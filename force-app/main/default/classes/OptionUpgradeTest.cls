@isTest
public with sharing class OptionUpgradeTest {

    @TestSetup
    static void testData(){
        buildertek__Section__c section = new buildertek__Section__c();
        section.Name = 'Selection Category Testing';
        insert section;

        buildertek__Question_Group__c selectionType = new buildertek__Question_Group__c();
        selectionType.Name = 'Selection Type Testing';
        selectionType.buildertek__Section__c = section.Id;
        insert selectionType;

        buildertek__Question__c option = new buildertek__Question__c();
        option.Name = 'Optoin Testing';
        option.buildertek__Question_Group__c = selectionType.Id;
        option.buildertek__Section__c = section.Id;
        option.buildertek__Upgrade_Costs__c = 35;
        option.buildertek__Quantity__c = 10;
        option.buildertek__Upgrade__c = true;
        insert option;
    }

    @isTest
    static void testMethod1(){
        buildertek__Question__c option = [SELECT Id, Name FROM buildertek__Question__c LIMIT 1];
        OptionUpgrade.getDetails(option.Id, 1, 10, 't', 'q', 'j', 'c');
    }
}