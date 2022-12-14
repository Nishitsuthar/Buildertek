@isTest
public with sharing class newPaymentAppOverrideControllerTest {
    @TestSetup
    static void testData() {
        Id pId = [select id from profile where name='System Administrator'].id;

        User user = new User();
        user.alias = 'test123';
        user.email = 'test123@noemail.com';
        user.emailencodingkey = 'UTF-8';
        user.lastname = 'Testing';
        user.languagelocalekey = 'en_US';
        user.localesidkey = 'en_US';
        user.profileid = pId;
        user.country = 'United States';
        user.IsActive = true;
        user.timezonesidkey = 'America/Los_Angeles';
        user.username = 'tester@noemail.com';
        insert user;

        Account acc = new Account();
        acc.Name = 'Testing Account';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Nm1';
        con.LastName = 'Test contact';
        con.email='test@test.com';
        insert con;

        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('MSAForm.pdf');
        efa.setBody(bodyBlob);

        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate LIMIT 1];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] sendTo = new String[]{'XXXXXXXXX@gmail.com'};
        email.setToAddresses(sendTo);
        email.setTemplateID(emailTemplate.Id);
        email.setTargetObjectId(con.Id);
        email.setHtmlBody(con.Name);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{ efa });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email }); 

        buildertek__Project__c project = new buildertek__Project__c();
        project.Name = 'Testing Project';
        insert project;

        buildertek__SOV_Payment_Application__c app = new buildertek__SOV_Payment_Application__c();
        app.Name = 'Test app';
        app.buildertek__Retainage__c = 10;
        insert app;

        buildertek__SOV_Continuation__c sov = new buildertek__SOV_Continuation__c();
        sov.Name = 'Test';
        sov.buildertek__SOV_Payment_Application__c = app.Id;
        insert sov;

        buildertek__Admin_Interface_Node_Configuration__c admin = new buildertek__Admin_Interface_Node_Configuration__c();
        admin.Name = 'SOV Configuration';
        insert admin;

        buildertek__Admin_Interface_Node_Configuration__c admin1 = new buildertek__Admin_Interface_Node_Configuration__c();
        admin1.Name = 'Payment Application Configuration';
        insert admin1;

        buildertek__Budget__c budget = new buildertek__Budget__c();
        budget.Name = 'test';
        insert budget;

        buildertek__Budget_Item__c budgetItem = new buildertek__Budget_Item__c();
        budgetItem.Name = 'Test';
        budgetItem.buildertek__Budget__c = budget.Id;
        insert budgetItem;

        buildertek__SOV_Continuation_Sheet_Lines__c sheetLine = new buildertek__SOV_Continuation_Sheet_Lines__c();
        sheetLine.Name = budgetItem.Name;
        // sheetLine.buildertek__Budget_Grouping__c = 'Change Orders';
        // sheetLine.buildertek__Is_Created_In_This_App__c = true;
        sheetLine.buildertek__Description_of_Work__c = budgetItem.Name;
        sheetLine.buildertek__SOV_Continuation_Sheet__c = sov.Id;
        insert sheetLine;

        buildertek__Schedule_of_Values__c schedule = new buildertek__Schedule_of_Values__c();
        schedule.Name = 'Test';
        insert schedule;

        buildertek__Schedule_of_Value_Lines__c svLine = new buildertek__Schedule_of_Value_Lines__c();
        svLine.buildertek__Item__c = 'testing';
        svLine.buildertek__Schedule_of_Values__c = schedule.Id;
        svLine.buildertek__Item_New__c = 6;
        svLine.buildertek__Description_of_Work__c = 'test';
        insert svLine;
    }

    @isTest
    static void testMethod1(){
        buildertek__SOV_Payment_Application__c app = [SELECT id,Name,buildertek__Retainage__c FROM buildertek__SOV_Payment_Application__c LIMIT 1];

        buildertek__SOV_Continuation__c sov = [SELECT Id,Name,buildertek__SOV_Payment_Application__c FROM buildertek__SOV_Continuation__c LIMIT 1];

        ListView lv = [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType, IsSoqlCompatible, CreatedDate, 
                        CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name, LastViewedDate, LastReferencedDate 
                        FROM ListView WHERE SobjectType = 'buildertek__Schedule_of_Values__c' AND Name='All'];

        buildertek__Schedule_of_Values__c sValue = [SELECT Id, Name FROM buildertek__Schedule_of_Values__c LIMIT 1];

        buildertek__Project__c project = [SELECT Id, Name FROM buildertek__Project__c LIMIT 1];

        Id recordTypeId = (Schema.SObjectType.buildertek__SOV_Payment_Application__c.getRecordTypeInfosByName().get('AP').getRecordTypeId());

        Test.startTest();

        newPaymentAppOverrideController.getRfqTo1();
        // newPaymentAppOverrideController.GetSheetid(app.Id);
        newPaymentAppOverrideController.GetadmindetailsforPA();
        newPaymentAppOverrideController.Getadmindetails();
        newPaymentAppOverrideController.getUser();
        newPaymentAppOverrideController.saveCommunityUserId(app.Id,'test');
        //newPaymentAppOverrideController.createlinesnewApp('Pay');
        newPaymentAppOverrideController.deleteline(sov.Id);
        newPaymentAppOverrideController.getListViews();
        newPaymentAppOverrideController.updateSubmittedDate(sValue.Id);
        newPaymentAppOverrideController.isSovSubmitted(sValue.Id);
        newPaymentAppOverrideController.CheckSovType(sValue.Id);
        newPaymentAppOverrideController.getmasterScheduleOValues(2,3);
        newPaymentAppOverrideController.getListViews1();
        newPaymentAppOverrideController.getPaymentListViews();
        newPaymentAppOverrideController.getRecordTypeName(recordTypeId);        

        Test.stopTest();
    }

    @isTest
    static void testMethod2(){
        ListView lv = [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType, IsSoqlCompatible, CreatedDate, 
                        CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name, LastViewedDate, LastReferencedDate 
                        FROM ListView WHERE SobjectType = 'buildertek__SOV_Payment_Application__c' and Name='All'];

        buildertek__Project__c project = [SELECT Id, Name FROM buildertek__Project__c LIMIT 1];

        buildertek__Schedule_of_Values__c sValue = [SELECT Id, Name FROM buildertek__Schedule_of_Values__c LIMIT 1];
        List<String> sValueIdList = new List<String>{sValue.Id};

        buildertek__SOV_Payment_Application__c app = [SELECT id,Name,buildertek__Retainage__c FROM buildertek__SOV_Payment_Application__c LIMIT 1];

        buildertek__SOV_Continuation_Sheet_Lines__c sovLine = [SELECT Id, Name FROM buildertek__SOV_Continuation_Sheet_Lines__c LIMIT 1];

        Test.startTest();

        newPaymentAppOverrideController.getVendorPaymentApps(project.Id);
        newPaymentAppOverrideController.importScheduleOfValueItems(sValueIdList, app.Id, false);
        newPaymentAppOverrideController.getCompanyApprovedScheduleOValues(project.Id);
        newPaymentAppOverrideController.getCustomerApprovedScheduleOValues(project.Id);
        newPaymentAppOverrideController.importCompanyApprovedSOVLines(sValueIdList, app.Id);
        newPaymentAppOverrideController.importCustomerApprovedSOVLines(sValueIdList, app.Id);
        newPaymentAppOverrideController.getapprovedScheduleOfValue(1, 10, app.Id);

        Test.stopTest();
    }

    @isTest
    static void testMethod3(){

        buildertek__SOV_Payment_Application__c app = new buildertek__SOV_Payment_Application__c();
        app.Name = 'Test app';
        app.buildertek__Retainage__c = 10;
        insert app;

        buildertek__Schedule_of_Values__c sValue = [SELECT Id, Name FROM buildertek__Schedule_of_Values__c LIMIT 1];
        Id recordTypeId = (Schema.SObjectType.buildertek__SOV_Payment_Application__c.getRecordTypeInfosByName().get('AP').getRecordTypeId());
        buildertek__Project__c project = [SELECT Id, Name FROM buildertek__Project__c LIMIT 1];

        List<String> sovAppIdList = new List<String>{app.Id};

        Test.startTest();

        newPaymentAppOverrideController.getParentProject(sValue.Id);
        newPaymentAppOverrideController.importPaymentApps(sovAppIdList, app.Id);
        newPaymentAppOverrideController.GivingSharingForMasterSov(sValue.Id);
        newPaymentAppOverrideController.getVendorSovList(sValue.Id);
        newPaymentAppOverrideController.getFieldSet('buildertek__Schedule_of_Values__c', 'testing set');
        newPaymentAppOverrideController.getDropDown('buildertek__Schedule_of_Values__c', 'buildertek__Status__c');
        newPaymentAppOverrideController.getPARecord(app.Id);
        newPaymentAppOverrideController.createlines(app.Id, project.Id, recordTypeId);
        
        Test.stopTest();
    }

    @isTest
    static void testMethod4(){

        Id recordTypeId = (Schema.SObjectType.buildertek__Schedule_of_Values__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId());

        buildertek__Schedule_of_Values__c sValue = [SELECT Id, Name FROM buildertek__Schedule_of_Values__c LIMIT 1];
        sValue.RecordTypeId = recordTypeId;
        update sValue;

        List<String> sValueIdList = new List<String>{sValue.Id};

        buildertek__SOV_Payment_Application__c app = [select id,Name,buildertek__Retainage__c from buildertek__SOV_Payment_Application__c LIMIT 1];

        Test.startTest();
        
        newPaymentAppOverrideController.importCompanyApprovedSOVLines(sValueIdList, app.Id);

        Test.stopTest();
    }
}