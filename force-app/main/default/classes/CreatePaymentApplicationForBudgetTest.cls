@isTest
public with sharing class CreatePaymentApplicationForBudgetTest {
    @TestSetup
    static void testData(){

        buildertek__Project__c project = new buildertek__Project__c();
        project.Name = 'Test Project';
        insert project;

        Account acc = new Account();
        acc.Name = 'Testing';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'Testing Contact';
        insert con;

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
        paymentApp.buildertek__Application__c = 'test application';
        paymentApp.buildertek__Architect__c = acc.Id;
        paymentApp.buildertek__Contract_Date__c = System.today();
        paymentApp.buildertek__Vendor__c = acc.Id;
        paymentApp.buildertek__Project__c = project.Id;
        paymentApp.buildertek__Contract_For__c = 'testing contract';
        insert paymentApp;

        buildertek__SOV_Continuation__c sov = new buildertek__SOV_Continuation__c();
        sov.Name = ' Testing SOV';
        sov.buildertek__SOV_Payment_Application__c = paymentApp.Id;
        insert sov;

        buildertek__SOV_Continuation_Sheet_Lines__c sovLine = new buildertek__SOV_Continuation_Sheet_Lines__c();
        sovLine.Name  = 'Testing SOV';
        sovLine.buildertek__SOV_Continuation_Sheet__c = sov.Id;
        sovLine.buildertek__Description_of_Work__c = 'Test Description';
        insert sovLine;
                    
    }

    @isTest
    static void testMethod1(){

        buildertek__Budget__c budget = [SELECT Id, Name FROM buildertek__Budget__c LIMIT 1];

        buildertek__SOV_Payment_Application__c paymentApp = [SELECT Id, Name FROM buildertek__SOV_Payment_Application__c LIMIT 1];

        buildertek__SOV_Continuation__c sov = [SELECT Id, Name FROM buildertek__SOV_Continuation__c LIMIT 1];


        Test.startTest();

        CreatePaymentApplicationForBudget.getRfqTo();
        CreatePaymentApplicationForBudget.getChangeOrderBtValue();
        CreatePaymentApplicationForBudget.getFieldSet();
        CreatePaymentApplicationForBudget.getPaymentApplications(budget.Id);
        CreatePaymentApplicationForBudget.insertContinuationSheet(sov, paymentApp.Id, '123');
        CreatePaymentApplicationForBudget.getPaymentRecord(paymentApp.Id);
        CreatePaymentApplicationForBudget.checkPeriodTo(paymentApp.Id);

        Test.stopTest();
    
    }

    @isTest
    static void testMethod2(){

        buildertek__Budget__c budget = [SELECT Id, Name FROM buildertek__Budget__c LIMIT 1];

        buildertek__SOV_Payment_Application__c paymentApp = [SELECT Id, Name, buildertek__Application__c, buildertek__Architect__c, buildertek__Contract_Date__c, buildertek__Vendor__c, buildertek__Project__c, buildertek__Contract_For__c FROM buildertek__SOV_Payment_Application__c LIMIT 1];

        buildertek__SOV_Continuation__c sov = [SELECT Id, Name FROM buildertek__SOV_Continuation__c LIMIT 1];

        List<String> PAIds = new List<String>{paymentApp.Id};

        buildertek__SOV_Payment_Application__c paymentApp1 = new buildertek__SOV_Payment_Application__c();
        paymentApp1.Name = 'Testing paymentApp';
        paymentApp1.buildertek__Retainage__c = 5;
        insert paymentApp1;

        String json=		'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__Description_of_Work__c": "test"'+
		'  }'+
		']';

        Test.startTest();

        CreatePaymentApplicationForBudget.InsertApplication(paymentApp, 'Demo', System.today());
        CreatePaymentApplicationForBudget.getContinuationSheetLines(sov.Id);
        CreatePaymentApplicationForBudget.importContinuationLines(PAIds, paymentApp.Id);
        CreatePaymentApplicationForBudget.getDropDown('buildertek__SOV_Continuation_Sheet_Lines__c', 'buildertek__Status__c');
        CreatePaymentApplicationForBudget.AceptConnLines(paymentApp1.Id);
        // CreatePaymentApplicationForBudget.createSheetLines(json, paymentApp.Id);
        
        Test.stopTest();
    
    }
}