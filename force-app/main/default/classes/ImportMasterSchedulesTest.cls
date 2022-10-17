@isTest
private class ImportMasterSchedulesTest {
    
    public static testMethod void test1() {
        Contact c = new Contact();
        c.LastName='Test';
        c.email='test@gmail.com'; 
        insert c;        

        buildertek__Project__c proj = new buildertek__Project__c();
        proj.Name = 'Test Project';
        insert proj;
        
        schedule__c sd = new schedule__c();
        sd.Description__c = 'test';
        sd.Type__c = 'Master';
        sd.Project__c = proj.Id;
        insert sd; 

        schedule__c sd1 = new schedule__c();
        sd1.Description__c = 'new record1';
        sd1.Type__c = 'new Record';
        sd1.Project__c = proj.Id;
        sd1.buildertek__Project_Manager__c = c.Id;
        sd1.buildertek__Initial_Start_Date__c = System.today();
        insert sd1; 
        
        Date iniStartDate = sd1.buildertek__Initial_Start_Date__c;
        String recordId = sd1.Id;
        String projectManagerId = sd1.buildertek__Project_Manager__c;
        list<string> schIds = new list<string>();
        list<buildertek__Project_Task__c> schItemlist = new list<buildertek__Project_Task__c>();
        buildertek__Project_Task__c schItem =new  buildertek__Project_Task__c();
        schItem.Name = 'test';
        schItem.buildertek__Schedule__c = sd.Id;
        schItem.buildertek__Start__c = system.today();
        schItem.buildertek__Duration__c = 20;
        schItem.buildertek__Phase__c = 'Ground Work';
        schItemlist.add(schItem);
        insert schItemlist; 
        schIds.add(sd.Id); 
        
        ImportMasterSchedules.importMasterScheduleLines(schIds, recordId, iniStartDate, projectManagerId);
        // ApexPages.StandardController sc = new ApexPages.StandardController(sd);
        // ImportMasterSchedules impsch = new ImportMasterSchedules(sc);
        // // impsch.MasterScheduleClass impmaster = new ImportMasterSchedules.MasterScheduleClass();
        // impsch.getMasterSchedule(sd.Id);
        // impsch.importMasterScheduleLines(schIds, sd.Id, system.today());
        // System.assertEquals('Test','Test');
        
        
        
        
    }
    
}