global with sharing class UpdateProjecttOnScheduleUpdateHandler  {
    public void updateProjectList(List<buildertek__Project__c> updateprojectListFromschedule){
        updateProjectDataInner handler = new updateProjectDataInner(); 
        handler.updateProjectListInnerMethod(updateprojectListFromschedule);
      
    }
    
    public void updateProjectList_New(List<buildertek__Project__c> updateprojectListFromschedule){
        updateProjectDataInner handler = new updateProjectDataInner(); 
        handler.updateProjectListInnerMethod_New(updateprojectListFromschedule);
      
    }
    
    /**
     * WITHOUT SHARING USED:
     * =====================
     * 
     */ 
    public without sharing class updateProjectDataInner{
        public void updateProjectListInnerMethod(List<buildertek__Project__c> updateprojectListFromscheduleClone){
            if(updateprojectListFromscheduleClone.size() > 0){
                update updateprojectListFromscheduleClone;
            }
            
        }
        public void updateProjectListInnerMethod_New(List<buildertek__Project__c> updateprojectListFromscheduleClone){
            if(updateprojectListFromscheduleClone.size() > 0){
                update updateprojectListFromscheduleClone;
            }
            
        }
    }
    
    }
    
    

/*public without sharing class UpdateProjecttOnScheduleUpdateHandler {
    public void updateProjectList(List<buildertek__Project__c> updateprojectListFromschedule){
        if(updateprojectListFromschedule.size() > 0)
            update updateprojectListFromschedule;
    }
}*/