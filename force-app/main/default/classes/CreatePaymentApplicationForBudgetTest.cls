@isTest
public with sharing class CreatePaymentApplicationForBudgetTest {
    @TestSetup
    static void testData(){

        buildertek__BT_Payment_App_Sign_Url__c payapp = new buildertek__BT_Payment_App_Sign_Url__c();
        // payapp.Name='a4t1K000000QZe4';
        payapp.buildertek__Site_Url__c='https://buildertekcom-developer-edition.na75.force.com/vendor';
        payapp.buildertek__Name__c ='BT Payment App Sign Url';
       insert payapp;


        buildertek__Project__c project = new buildertek__Project__c();
        project.Name = 'Test Project';
        insert project;

        Account acc = new Account();
        acc.Name = 'Testing';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'Testing Contact';
        con.Email = 'Testing@gmail.com';

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
        paymentApp.buildertek__Period_To__c = system.today();

        insert paymentApp;

        buildertek__SOV_Continuation__c sov = new buildertek__SOV_Continuation__c();
        sov.Name = ' Testing SOV';
        sov.buildertek__SOV_Payment_Application__c = paymentApp.Id;
        insert sov;

        buildertek__SOV_Continuation_Sheet_Lines__c sovLine = new buildertek__SOV_Continuation_Sheet_Lines__c();
        sovLine.Name  = 'Testing SOV';
        sovLine.buildertek__SOV_Continuation_Sheet__c = sov.Id;
        sovLine.buildertek__Description_of_Work__c = 'Test Description';
        sovLine.buildertek__Grouping__c  = '1st Floor';
        sovLine.buildertek__Item_No__c  = 1;
        insert sovLine;
                    
    }

    @isTest
    static void testMethod1(){

        buildertek__Budget__c budget = [SELECT Id, Name FROM buildertek__Budget__c LIMIT 1];

        buildertek__SOV_Payment_Application__c paymentApp = [SELECT Id, Name FROM buildertek__SOV_Payment_Application__c LIMIT 1];

        buildertek__SOV_Continuation__c sov = [SELECT Id, Name FROM buildertek__SOV_Continuation__c LIMIT 1];

        buildertek__SOV_Payment_Application__c paymentApp1 = new buildertek__SOV_Payment_Application__c();

        buildertek__SOV_Continuation_Sheet_Lines__c sovContLine= [Select id , Name ,buildertek__Description_of_Work__c , buildertek__SOV_Continuation_Sheet__c   from buildertek__SOV_Continuation_Sheet_Lines__c Limit 1];

        paymentApp1.Name = 'Testing paymentApp';
        paymentApp1.buildertek__Retainage__c = 5;
        insert paymentApp1;

        Test.startTest();

        CreatePaymentApplicationForBudget.getRfqTo();
        CreatePaymentApplicationForBudget.getChangeOrderBtValue();
        CreatePaymentApplicationForBudget.getFieldSet();
        CreatePaymentApplicationForBudget.getPaymentApplications(budget.Id);
        CreatePaymentApplicationForBudget.insertContinuationSheet(sov, paymentApp.Id, '123');
        CreatePaymentApplicationForBudget.getPaymentRecord(paymentApp.Id);
        CreatePaymentApplicationForBudget.checkPeriodTo(paymentApp.Id);
        CreatePaymentApplicationForBudget.InsertApplication(paymentApp, null , null);
        CreatePaymentApplicationForBudget.getPaymentAppStatus(sov.Id);
        CreatePaymentApplicationForBudget.updateFormula(sovContLine.Id , sov.Id , 'buildertek__Scheduled_Value__c'  , 1 );



        Test.stopTest();
    
    }

    @isTest
    static void testMethod2(){

        buildertek__Budget__c budget = [SELECT Id, Name FROM buildertek__Budget__c LIMIT 1];


        buildertek__SOV_Continuation__c sov = [SELECT Id, Name FROM buildertek__SOV_Continuation__c LIMIT 1];
        buildertek__SOV_Payment_Application__c paymentApp = [SELECT Id, Name, buildertek__Application__c, buildertek__Retainage__c ,buildertek__Architect__c, buildertek__Contract_Date__c, buildertek__Vendor__c, buildertek__Project__c, buildertek__Contract_For__c FROM buildertek__SOV_Payment_Application__c   LIMIT 1];

        List<String> PAIds = new List<String>{paymentApp.Id};

        List<String> coId= new  List<String> ();

        buildertek__Change_Order__c co=new buildertek__Change_Order__c();
        co.name='test';
        insert co;

        buildertek__Change_Order__c co2=new buildertek__Change_Order__c();
        co2.name='test';
        insert co2;

        coId.add(co.Id);
        coId.add(co2.Id);

        
         
        buildertek__SOV_Payment_Application__c payRec = new buildertek__SOV_Payment_Application__c();
        payRec.Name = 'Test PAyment';
        payRec.buildertek__Retainage__c = 10;
        payRec.buildertek__Period_To__c = system.today();
        insert payRec;

        String json=		'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__SOV_Continuation_Sheet__c": "'+payRec.Id+'"'+
		'  }'+
		']';
       
        
         String jsonData=		'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__SOV_Payment_Application__c": "'+payRec.Id+'"'+
		'  };'+
        '  {'+
		'    "Name": "test2",'+
		'    "buildertek__SOV_Payment_Application__c": "'+payRec.Id+'"'+
		'  }'+
		']';

        String sheetLineData=	'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__Description_of_Work__c": "test"'+
		'  }'+
		']';

        buildertek__SOV_Payment_Application__c sovList = [SELECT Id, Name, buildertek__Application__c,buildertek__Period_To__c , buildertek__Retainage__c , buildertek__Architect__c, buildertek__Contract_Date__c, buildertek__Project__c , buildertek__Vendor__c, buildertek__Contract_For__c FROM buildertek__SOV_Payment_Application__c  where id=:paymentApp.Id  LIMIT 1];

        buildertek__BT_Payment_App_Sign_Url__c payapp=[SELECT Id, Name, buildertek__Site_Url__c, buildertek__Name__c FROM buildertek__BT_Payment_App_Sign_Url__c];

        buildertek__SOV_Continuation__c sov2 = new buildertek__SOV_Continuation__c();
        sov.Name = ' Testing SOV';
        sov.buildertek__SOV_Payment_Application__c = paymentApp.Id;

        buildertek__Project__c project =[Select id , name From buildertek__Project__c Limit 1];
        buildertek__SOV_Continuation_Sheet_Lines__c sovContLine= [Select id , Name ,buildertek__Description_of_Work__c , buildertek__SOV_Continuation_Sheet__c   from buildertek__SOV_Continuation_Sheet_Lines__c Limit 1];
        List<String> sheetlineIds= new List<String>();
        sheetlineIds.add(sovContLine.Id);


        // buildertek__SOV_Continuation__c sovContinous = new buildertek__SOV_Continuation__c();
        // sov.Name = ' Testing SOV';
        // sov.buildertek__SOV_Payment_Application__c = paymentApp.Id;
        // insert sov;

        // buildertek__SOV_Continuation_Sheet_Lines__c sovLine = new buildertek__SOV_Continuation_Sheet_Lines__c();
        // sovLine.Name  = 'Testing SOV';
        // sovLine.buildertek__SOV_Continuation_Sheet__c = sov.Id;
        // sovLine.buildertek__Description_of_Work__c = 'Test Description';
        // sovLine.buildertek__Grouping__c  = '1st Floor';
        // sovLine.buildertek__Item_No__c  = 1;
        // sovLine.buildertek__Scheduled_Value__c  = 7000;
        // sovLine.buildertek__Work_Completed_from_Previous_Application__c  = 500;
        // sovLine.buildertek__Work_Completed__c  = 500;
        // sovLine.buildertek__Material_Presently_Stored__c  = 200;
        // sovLine.buildertek__Status__c  = 'Accepted';
        // sovLine.buildertek__Grouping2__c  = 'Section A';
        // sovLine.buildertek__Budget_Grouping__c  = 'Test';
        // sovLine.buildertek__Rejection_Reason__c  = 'Test Rejection reason';
        // insert sovLine;

        



      
        Test.startTest();
        CreatePaymentApplicationForBudget.InsertApplication(sovList, 'Demo', System.today());
        CreatePaymentApplicationForBudget.getContinuationSheetLines(sov.Id);
        CreatePaymentApplicationForBudget.importContinuationLines(PAIds, payRec.Id);
        CreatePaymentApplicationForBudget.getDropDown('buildertek__SOV_Continuation_Sheet_Lines__c', 'buildertek__Status__c');
        CreatePaymentApplicationForBudget.AceptConnLines(payRec.Id);
         CreatePaymentApplicationForBudget.createSheetLines(json, payRec.Id);
         CreatePaymentApplicationForBudget.insertContinuationSheet(sov2, payRec.Id, '123');
         CreatePaymentApplicationForBudget.getLienRelease(payRec.Id);
         CreatePaymentApplicationForBudget.getadminvalues();
         CreatePaymentApplicationForBudget.getPaymentAppStatus(paymentApp.Id);
         CreatePaymentApplicationForBudget.getVendorSubmittedPaymentApps(project.Id , paymentApp.Id);
         CreatePaymentApplicationForBudget.getstatus(sovContLine.Id);
         CreatePaymentApplicationForBudget.getreason(sovContLine.Id);
         CreatePaymentApplicationForBudget.isSovSubmitted(paymentApp.Id);
         CreatePaymentApplicationForBudget.getCommUser();
         CreatePaymentApplicationForBudget.createSheetLinesNew(coId , paymentApp.Id);
         CreatePaymentApplicationForBudget.updateSheetLines(sheetLineData , sovContLine.Id, paymentApp.Id);
         CreatePaymentApplicationForBudget.acceptsheetline(sheetlineIds , sovContLine.Id);
         CreatePaymentApplicationForBudget.rejectsheetline(sheetlineIds ,'test' );
         CreatePaymentApplicationForBudget.updateFormula(sovContLine.Id , sov.Id , 'buildertek__Work_Completed_from_Previous_Application__c'  , 1 );
        //  CreatePaymentApplicationForBudget.deletesheetline(sheetlineIds);
        Test.stopTest();
    
    }
    @isTest
    static void testMethod4(){

        buildertek__Budget__c budget = [SELECT Id, Name FROM buildertek__Budget__c LIMIT 1];


        buildertek__SOV_Continuation__c sov = [SELECT Id, Name FROM buildertek__SOV_Continuation__c LIMIT 1];
        buildertek__SOV_Payment_Application__c paymentApp = [SELECT Id, Name, buildertek__Application__c, buildertek__Retainage__c ,buildertek__Architect__c, buildertek__Contract_Date__c, buildertek__Vendor__c, buildertek__Project__c, buildertek__Contract_For__c FROM buildertek__SOV_Payment_Application__c   LIMIT 1];

        List<String> PAIds = new List<String>{paymentApp.Id};

        List<String> coId= new  List<String> ();

        buildertek__Change_Order__c co=new buildertek__Change_Order__c();
        co.name='test';
        insert co;

        buildertek__Change_Order__c co2=new buildertek__Change_Order__c();
        co2.name='test';
        insert co2;

        coId.add(co.Id);
        coId.add(co2.Id);

        
         
        buildertek__SOV_Payment_Application__c payRec = new buildertek__SOV_Payment_Application__c();
        payRec.Name = 'Test PAyment';
        payRec.buildertek__Retainage__c = 10;
        payRec.buildertek__Period_To__c = system.today();
        insert payRec;

        String json=		'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__SOV_Continuation_Sheet__c": "'+payRec.Id+'"'+
		'  }'+
		']';
       
        
         String jsonData=		'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__SOV_Payment_Application__c": "'+payRec.Id+'"'+
		'  };'+
        '  {'+
		'    "Name": "test2",'+
		'    "buildertek__SOV_Payment_Application__c": "'+payRec.Id+'"'+
		'  }'+
		']';

        String sheetLineData=	'['+
		'  {'+
		'    "Name": "test",'+
		'    "buildertek__Description_of_Work__c": "test"'+
		'  }'+
		']';

        buildertek__SOV_Payment_Application__c sovList = [SELECT Id, Name, buildertek__Application__c,buildertek__Period_To__c , buildertek__Retainage__c , buildertek__Architect__c, buildertek__Contract_Date__c, buildertek__Project__c , buildertek__Vendor__c, buildertek__Contract_For__c FROM buildertek__SOV_Payment_Application__c  where id=:paymentApp.Id  LIMIT 1];

        buildertek__BT_Payment_App_Sign_Url__c payapp=[SELECT Id, Name, buildertek__Site_Url__c, buildertek__Name__c FROM buildertek__BT_Payment_App_Sign_Url__c];

        buildertek__SOV_Continuation__c sov2 = new buildertek__SOV_Continuation__c();
        sov.Name = ' Testing SOV';
        sov.buildertek__SOV_Payment_Application__c = paymentApp.Id;

        buildertek__Project__c project =[Select id , name From buildertek__Project__c Limit 1];
        buildertek__SOV_Continuation_Sheet_Lines__c sovContLine= [Select id , Name , buildertek__Item_No__c, buildertek__SOV_Continuation_Sheet__r.buildertek__SOV_Payment_Application__c , buildertek__Description_of_Work__c , buildertek__SOV_Continuation_Sheet__c   from buildertek__SOV_Continuation_Sheet_Lines__c];
        List<String> sheetlineIds= new List<String>();
        sheetlineIds.add(sovContLine.Id);

      
        Test.startTest();
         CreatePaymentApplicationForBudget.updateFormula(sovContLine.Id , sov.Id , 'buildertek__Work_Completed__c'  , 1 );
         CreatePaymentApplicationForBudget.deletesheetline(sheetlineIds);
        Test.stopTest();
    
    }


}