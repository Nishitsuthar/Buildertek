public with sharing class ScheduleTriggerHandler{
    public static Boolean isFirstTime = true;
    public static Boolean isTask = true;
    //Boolean variable to allow skipping execution of trigger in certain scenarios
    public static Boolean blnSkipScheduleTrigger = false;
    public Boolean blnSkipTaskTrigger = false;
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public ScheduleTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    @Future(CallOut = true)
    public static void FutureMethodCallOut_ForUpdatingProject(Set<Id> projectIdSet){
        List<buildertek__Schedule__c> scheduleList;
        List<buildertek__Project__c> projectList = new List<buildertek__Project__c>();
        scheduleList = [SELECT Id, Name, buildertek__End_Date__c, buildertek__Primary_Schedule__c, buildertek__Start_Date__c, buildertek__Project__c
                        FROM buildertek__Schedule__c
                        WHERE buildertek__Project__c IN :projectIdSet
                        ORDER BY CreatedDate ASC];

        if (scheduleList.size() > 0){
            if (scheduleList.size() > 1){
                for (buildertek__Schedule__c schedule : scheduleList){
                    if (schedule.buildertek__Primary_Schedule__c == true){
                        if (schedule.buildertek__Project__c != null && String.isNotBlank(schedule.buildertek__Project__c)){
                            buildertek__Project__c proj = new buildertek__Project__c();
                            proj.Id = schedule.buildertek__Project__c;
                            proj.buildertek__Anticipated_Start_Date__c = schedule.buildertek__Start_Date__c;
                            proj.buildertek__Estimated_Completion_Date__c = schedule.buildertek__End_Date__c;
                            projectList.add(proj);
                        }
                    }
                }
            } else{
                for (buildertek__Schedule__c schedule : scheduleList){
                    if (schedule.buildertek__Project__c != null && String.isNotBlank(schedule.buildertek__Project__c)){
                        buildertek__Project__c proj = new buildertek__Project__c();
                        proj.Id = schedule.buildertek__Project__c;
                        proj.buildertek__Anticipated_Start_Date__c = schedule.buildertek__Start_Date__c;
                        proj.buildertek__Estimated_Completion_Date__c = schedule.buildertek__End_Date__c;
                        projectList.add(proj);
                    }
                    if(schedule.buildertek__Start_Date__c!=null && schedule.buildertek__End_Date__c!=null){
                    //futureContoller.updateScheduleRec(schedule.Id);
                    }
                }
            }
            update projectList;
        }
    }
    
    public void getScheduleItemCount(buildertek__Schedule__c[] schedules, Map<ID, buildertek__Schedule__c> schedulesMap){
       if(ScheduleTriggerHandler.isFirstTime){
            ScheduleTriggerHandler.isFirstTime = false;
            List<buildertek__Schedule__c> scheduleList = [select Id, (Select Id,buildertek__Milestone__c from buildertek__Schedule_Tasks__r) from buildertek__Schedule__c where Id IN:schedulesMap.keySet()];
            Map<String,Integer> scheduleAndTaskMap = new Map<String,Integer>();
            //[Select Id, buildertek__Schedule_Items_Count__c From buildertek__Schedule__c Where Id IN:schedulesMap.keySet()];
            List<buildertek__Schedule__c> updateScheduleList = new List<buildertek__Schedule__c>();
            //Integer TaskCount = [select count() from buildertek__Project_Task__c where buildertek__Schedule__c= 'a101K00000BQ8CuQAL'];
            for(buildertek__Schedule__c schItem: scheduleList){
                scheduleAndTaskMap.put(schItem.Id,schItem.buildertek__Schedule_Tasks__r.Size());
                buildertek__Schedule__c schRec = new buildertek__Schedule__c();
                schRec.Id = schItem.Id;
                schRec.buildertek__Schedule_Items_Count__c = schItem.buildertek__Schedule_Tasks__r.Size();
                if(schItem.buildertek__Start_Date__c!=null && schItem.buildertek__End_Date__c!=null){
           /*if(schItem.buildertek__Original_Start_Date__c==null && schItem.buildertek__Original_End_Date__c==null){
               schRec.buildertek__Original_Start_Date__c=schItem.buildertek__Start_Date__c;
                schRec.buildertek__Original_End_Date__c=schItem.buildertek__End_Date__c;
                }*/
           }
                for(buildertek__Project_Task__c task : schItem.buildertek__Schedule_Tasks__r){
                    system.debug(task);
                }
                system.debug(schItem.buildertek__Schedule_Tasks__r.size());
                updateScheduleList.add(schRec);
            }
            
            update updateScheduleList;
            
            /*buildertek__Schedule__c schRec = new buildertek__Schedule__c();
            schRec.Id = sch.Id;
            schRec.buildertek__Schedule_Items_Count__c = */
        }
    }
    
    //update original dates
     
 
   
}