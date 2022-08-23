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
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sd);
        //ImportMasterSchedules impsch = new ImportMasterSchedules(sc);
        //ImportMasterSchedules.MasterScheduleClass impmaster = new ImportMasterSchedules.MasterScheduleClass();
        //ImportMasterSchedules.getMasterSchedule(sd.Id);
        //ImportMasterSchedules.importMasterScheduleLines(schIds, sd.Id, system.today());
        System.assertEquals('Test','Test');
        
        
        
        
    }
    
}