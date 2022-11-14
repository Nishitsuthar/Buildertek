@isTest
public with sharing class CreatePaymentApplicationForBudgetTest {
    @TestSetup
    static void testData(){
        try {

            buildertek__Admin_Interface_Node_Configuration__c interfaceNode = new buildertek__Admin_Interface_Node_Configuration__c();
            interfaceNode.Name = 'Payment Application Configuration';
            interfaceNode.buildertek__Get_Lines_From_CO__c = true;
            insert interfaceNode;

            buildertek__Budget__c budget = new buildertek__Budget__c();
            budget.Name = 'Testing budget';
            insert budget;

            buildertek__SOV_Payment_Application__c paymentApp = new buildertek__SOV_Payment_Application__c();
            paymentApp.Name = 'Testing paymentApp';
            paymentApp.buildertek__Retainage__c = 5;
            insert paymentApp;

            buildertek__SOV_Continuation__c sov = new buildertek__SOV_Continuation__c();
            sov.Name = ' Testing SOV';
            insert sov;

            // buildertek__SOV_Continuation_Sheet_Lines__c sovLine = new buildertek__SOV_Continuation_Sheet_Lines__c();
            // sovLine.Name  = 'Testing SOV';
            // sovLine.buildertek__SOV_Continuation_Sheet__c = sov.Id;
            // sovLine.buildertek__Description_of_Work__c = 'Test Description';
            // insert sovLine;
                    
        } catch (Exception e) {
            System.debug('Error');
            System.debug('Error Message => '+e.getMessage());
            System.debug('Error Line no => '+e.getLineNumber());
        }

    }

    @isTest
    static void testMethod1(){
        try {
            buildertek__Budget__c budget = [SELECT Id, Name FROM buildertek__Budget__c LIMIT 1];

            buildertek__SOV_Payment_Application__c paymentApp = [SELECT Id, Name FROM buildertek__SOV_Payment_Application__c LIMIT 1];
    
            buildertek__SOV_Continuation__c sov = [SELECT Id, Name FROM buildertek__SOV_Continuation__c LIMIT 1];
    
            List<String> PAIds = new List<String>{paymentApp.Id};
    
            Test.startTest();
    
            CreatePaymentApplicationForBudget.getRfqTo();
            CreatePaymentApplicationForBudget.getChangeOrderBtValue();
            CreatePaymentApplicationForBudget.getFieldSet();
            CreatePaymentApplicationForBudget.getPaymentApplications(budget.Id);
            CreatePaymentApplicationForBudget.InsertApplication(paymentApp, 'Demo', System.today());
            CreatePaymentApplicationForBudget.getContinuationSheetLines(paymentApp.Id);
            CreatePaymentApplicationForBudget.getContinuationSheetLines(sov.Id);
            CreatePaymentApplicationForBudget.importContinuationLines(PAIds, paymentApp.Id);
            CreatePaymentApplicationForBudget.getDropDown('buildertek__SOV_Continuation_Sheet_Lines__c', 'buildertek__Status__c');
    
            Test.stopTest();
    
        } catch (Exception e) {
            System.debug('Error');
            System.debug('Error Message => '+e.getMessage());
            System.debug('Error Line no => '+e.getLineNumber());
        }

     
    }
}