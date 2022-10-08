public with sharing class ImportMasterSchedules{
    /**/
     @AuraEnabled
     public static object getMasterSchedule(String recordId){
     List<buildertek__Schedule__c> schedulesList;
     /* if (Schema.sObjectType.buildertek__Schedule__c.fields.Id.isAccessible() &&
     Schema.sObjectType.buildertek__Schedule__c.fields.Name.isAccessible() &&
     Schema.sObjectType.buildertek__Schedule__c.fields.buildertek__Description__c.isAccessible() &&
     Schema.sObjectType.buildertek__Schedule__c.fields.buildertek__Type__c.isAccessible() ){  */
    schedulesList = [SELECT Id, Name, buildertek__Description__c, buildertek__Type__c, buildertek__Community__c
                     FROM buildertek__Schedule__c
                     WHERE buildertek__Type__c = 'Master' AND Id != :recordId];
    //}
    List<MasterScheduleClass> MasterScheduleClassList = new List<MasterScheduleClass>();
    for (buildertek__Schedule__c sch : schedulesList){
        MasterScheduleClass MasterScheduleClassRecord = new MasterScheduleClass();
        MasterScheduleClassRecord.masterscheduleRecord = sch;
        MasterScheduleClassRecord.scheduleCheck = false;
        MasterScheduleClassList.add(MasterScheduleClassRecord);
    }
    return MasterScheduleClassList;
}

@AuraEnabled
public static MessageClass importMasterScheduleLines(List<String> scheduleRecIds, String recordId, Date initialDate, String projectManagerId){
    MessageClass msg = new MessageClass();
    Map<Id, buildertek__Project_Task__c> projectTaskMap = new Map<Id, buildertek__Project_Task__c>();
    List<buildertek__Project_Task__c> projectTask = new List<buildertek__Project_Task__c>();
    Set<String> listOfPhase = new Set<String>();
    system.debug(recordId + '--------------' + scheduleRecIds);
    try{
        list<buildertek__Project_Task__c> scheduleitems = new list<buildertek__Project_Task__c>();
        list<buildertek__Project_Task__c> existedScheduleitems = new list<buildertek__Project_Task__c>();
        /*if (Schema.sObjectType.buildertek__Project_Task__c.fields.Id.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Completion__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Contractor__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Contractor_Resource__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Duration__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Finish__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Resource__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Lag__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Dependency__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Milestone__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Notes__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Order__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Original_End_Date__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Original_Start_Date__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Phase__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Type__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Dependency__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Project__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Purchase_Order__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Reason_for_Date_Change__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Reason_for_Date_Change_PL__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Required_Completion_Date__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.buildertek__Schedule__c.isAccessible() &&
         Schema.sObjectType.buildertek__Project_Task__c.fields.Name.isAccessible()){ */
         
     //    List<buildertek__Schedule__c> schRecords =  [SELECT Id,buildertek__Project_Manager__c From buildertek__Schedule__c WHERE Id=:recordId];
     //   System.debug('Schedule Record -------------> '+schRecords);
        scheduleitems = [select id, buildertek__Completion__c, buildertek__Contractor__c, buildertek__Contractor_Resource__c,buildertek__Project_Manager__c, buildertek__Duration__c, buildertek__Finish__c, buildertek__Resource__c, buildertek__Lag__c, buildertek__Milestone__c, buildertek__Notes__c, buildertek__Order__c, buildertek__Original_End_Date__c, buildertek__Original_Start_Date__c, buildertek__Phase__c, buildertek__Type__c, buildertek__Dependency__c, buildertek__Project__c, buildertek__Purchase_Order__c, buildertek__Reason_for_Date_Change__c, buildertek__Reason_for_Date_Change_PL__c, buildertek__Required_Completion_Date__c, buildertek__Schedule__c, buildertek__Start__c, Name
                         from buildertek__Project_Task__c
                         where buildertek__Schedule__c IN :scheduleRecIds order by CreatedDate,buildertek__Order__c NULLS LAST];

        if(initialDate ==null){
            initialDate = [SELECT Id,buildertek__Initial_Start_Date__c From buildertek__Schedule__c WHERE Id=:recordId].buildertek__Initial_Start_Date__c;
        }
        
        existedScheduleitems = [select id, buildertek__Completion__c, buildertek__Contractor__c, buildertek__Contractor_Resource__c, buildertek__Duration__c, buildertek__Finish__c, buildertek__Resource__c, buildertek__Lag__c, buildertek__Milestone__c, buildertek__Notes__c, buildertek__Order__c, buildertek__Original_End_Date__c, buildertek__Original_Start_Date__c, buildertek__Phase__c, buildertek__Type__c, buildertek__Dependency__c, buildertek__Project__c, buildertek__Purchase_Order__c, buildertek__Reason_for_Date_Change__c, buildertek__Reason_for_Date_Change_PL__c, buildertek__Required_Completion_Date__c, buildertek__Schedule__c, buildertek__Start__c, Name
                         from buildertek__Project_Task__c
                         where buildertek__Schedule__c  =:recordId AND buildertek__Milestone__c =: false order by CreatedDate,buildertek__Order__c NULLS LAST];
        
        Integer lastIndex = -1;
        if(existedScheduleitems.Size() > 0){
            lastIndex = existedScheduleitems.Size() - 1;
            if(lastIndex >=0){
                system.debug(existedScheduleitems[lastIndex]);
            }
        }
        
        // }
        Integer count = 1;
        if(lastIndex >=0){
            if(Integer.valueOf(existedScheduleitems[lastIndex].buildertek__Order__c) == null){
               existedScheduleitems[lastIndex].buildertek__Order__c = 0;
            }
            count = Integer.valueOf(existedScheduleitems[lastIndex].buildertek__Order__c)+1;
                system.debug(existedScheduleitems[lastIndex]);
            }
        if (scheduleitems.size() > 0){
            for (buildertek__Project_Task__c scheduleitem : scheduleitems){
                if (!scheduleitem.buildertek__Milestone__c){
                    buildertek__Project_Task__c schItem = new buildertek__Project_Task__c();
                    schItem.buildertek__Completion__c = scheduleitem.buildertek__Completion__c;
                    schItem.buildertek__Contractor__c = scheduleitem.buildertek__Contractor__c;
                    schItem.buildertek__Contractor_Resource__c = scheduleitem.buildertek__Contractor_Resource__c;
                    if (scheduleitem.buildertek__Duration__c != 0 && scheduleitem.buildertek__Duration__c != null){
                        schItem.buildertek__Duration__c = scheduleitem.buildertek__Duration__c;
                    } else{
                        schItem.buildertek__Duration__c = 1;
                    }
                    System.debug('check one');
                      if(projectManagerId != null){
                      schItem.buildertek__Project_Manager__c =  projectManagerId;
                      
                      }
                 /*    if(schRecords.size() > 0){
                     System.debug('Check Two');
                     if(schRecords[0].buildertek__Project_Manager__c != null){
                     System.debug('Check Three');
                        schItem.buildertek__Project_Manager__c = schRecords[0].buildertek__Project_Manager__c;
                        }
                    }  */
                    // schItem.buildertek__Dependency__c = scheduleitem.buildertek__Dependency__c;
                    schItem.buildertek__Finish__c = scheduleitem.buildertek__Finish__c;
                    schItem.buildertek__Resource__c = scheduleitem.buildertek__Resource__c;
                    schItem.buildertek__Lag__c = scheduleitem.buildertek__Lag__c;
                    schItem.buildertek__Milestone__c = scheduleitem.buildertek__Milestone__c;
                    schItem.buildertek__Notes__c = scheduleitem.buildertek__Notes__c;
                    schItem.buildertek__Order__c = scheduleitem.buildertek__Order__c;
                    schItem.buildertek__Original_Start_Date__c = Date.today();
                    schItem.buildertek__Original_End_Date__c = Date.today().adddays(Integer.valueOf(scheduleitem.buildertek__Duration__c));
                    schItem.buildertek__Phase__c = scheduleitem.buildertek__Phase__c;
                    schItem.buildertek__Type__c = scheduleitem.buildertek__Type__c;
                    schItem.buildertek__Project__c = scheduleitem.buildertek__Project__c;
                    schItem.buildertek__Purchase_Order__c = scheduleitem.buildertek__Purchase_Order__c;
                    schItem.buildertek__Reason_for_Date_Change__c = scheduleitem.buildertek__Reason_for_Date_Change__c;
                    schItem.buildertek__Reason_for_Date_Change_PL__c = scheduleitem.buildertek__Reason_for_Date_Change_PL__c;
                    schItem.buildertek__Required_Completion_Date__c = scheduleitem.buildertek__Required_Completion_Date__c;
                    schItem.buildertek__Schedule__c = recordId;
                    schItem.buildertek__Order__c = count;
                    schItem.buildertek__Reference_for_Import__c = scheduleitem.Id;
                    if(initialDate !=null){
                        schItem.buildertek__Start__c = initialDate;
                    }else{//fromNewSchedule != null && fromNewSchedule && 
                        Date today = system.today();
                         schItem.buildertek__Start__c = today;
                    }//else{
                        //schItem.buildertek__Start__c = scheduleitem.buildertek__Start__c;
                    //}
                    
                   // schItem.buildertek__Start__c = scheduleitem.buildertek__Start__c;
                    schItem.Name = scheduleitem.Name;
                    buildertek__Project_Task__c schItemClone = schItem.Clone(false, true);
                    system.debug(schItemClone.buildertek__Phase__c);
                    projectTaskMap.put(scheduleitem.Id, schItemClone);
                    listOfPhase.add(schItem.buildertek__Phase__c);
                    system.debug(schItem);
                    count++;
                }
            }
            
            system.debug('projectTaskMap.values()'+projectTaskMap.values());
            
            // for(buildertek__Project_Task__c item:projectTaskMap.values() ){
            //     system.debug('item ===> '+item);
            // }
            insert projectTaskMap.values();            
            
            futureContoller.updateScheduleRec(recordId);
            
            System.debug('Check Project Manager 1');

            //system.debug([Select Id, Name, buildertek__Phase__c, buildertek__Start__c, buildertek__Schedule__c, buildertek__Milestone__c FROM Project_Task__c  WHERE buildertek__Schedule__c = :recordId]);
          for (buildertek__Project_Task__c scheduleitem : projectTaskMap.values()){
                buildertek__Project_Task__c schItem = new buildertek__Project_Task__c();
                system.debug('scheduleitem'+scheduleitem.buildertek__Phase__c);
                schItem.Id = scheduleitem.Id;
                if(scheduleitem.buildertek__Dependency__c != null && projectTaskMap.get(scheduleitem.buildertek__Dependency__c) != null){
                    if (String.isNotBlank(scheduleitem.buildertek__Dependency__c) && String.isNotBlank(projectTaskMap.get(scheduleitem.buildertek__Dependency__c).Id)){
                        schItem.buildertek__Dependency__c = projectTaskMap.get(scheduleitem.buildertek__Dependency__c).Id;
                    }
                }
                
                projectTask.add(schItem);
            }
           System.debug('Check Project Manager 2');
            ProjectTaskTriggerHandler.isFromImport = true;
            
            if (projectTask.size() > 0){
                update projectTask;
                msg.Status = 'Success';
                msg.Message = 'schedule Lines Imported Successfully';
                system.debug('Success---');
            }
           System.debug('Check Project Manager 3');
            /*updateScheduleItemTaskBacthApex updatedependency = new updateScheduleItemTaskBacthApex(projectTaskMap.keyset(),recordId,projectTaskMap);
            database.executeBatch(updatedependency, 200);*/
            
          /* updateScheduleItemTaskBacthApex updatedependency = new updateScheduleItemTaskBacthApex(projectTaskMap.keyset(),recordId,projectTaskMap);
            database.executeBatch(updatedependency, 200);*/

            
            Map<String, buildertek__Project_Task__c> milestoneList = new Map<String, buildertek__Project_Task__c>();
            Map<String, buildertek__Project_Task__c> projectTaskList = new Map<String, buildertek__Project_Task__c>();
            List<buildertek__Project_Task__c> projectTasks = new List<buildertek__Project_Task__c>();

            //If milestone not created for that Phase, Creates here.
            List<Project_Task__c> task = [Select Id, Name, buildertek__Phase__c, buildertek__Start__c, buildertek__Schedule__c, buildertek__Milestone__c
                                          FROM Project_Task__c
                                          WHERE buildertek__Schedule__c = :recordId];
            
            
            for (Project_Task__c tasks : task){
                if (!tasks.buildertek__Milestone__c){
                    system.debug(tasks.buildertek__Start__c);
                    projectTaskList.put(tasks.buildertek__Phase__c, tasks);
                } else{
                System.debug('Check Project Manager 4');
                    milestoneList.put(tasks.buildertek__Phase__c, tasks);
                }
            }
            system.debug('projectTaskList.values()'+projectTaskList.values());
            for (Project_Task__c tasks : projectTaskList.values()){
                system.debug('task'+tasks.buildertek__Start__c);
            }            
            for (Project_Task__c tasks : projectTaskList.values()){
                if (!milestoneList.containsKey(tasks.buildertek__Phase__c) && !tasks.buildertek__Milestone__c){
                System.debug('Check Project Manager 5');
                    if(tasks.buildertek__Phase__c != null){
                         system.debug('task214'+tasks.buildertek__Start__c);
                        Project_Task__c project = new Project_Task__c();
                        project.Name = 'Milestone Complete';
                        project.buildertek__Phase__c = tasks.buildertek__Phase__c;
                        project.buildertek__Start__c = tasks.buildertek__Start__c;
                        project.buildertek__Schedule__c = recordId;
                        project.buildertek__Use_Project_Manager_from_Schedule__c = true;
                        System.debug('Check Project Manager 6');
                        if(projectManagerId != null){
                            project.buildertek__Project_Manager__c = projectManagerId;
                            System.debug('Check Project Manager 7');
                        }
                       // project.buildertek__Use_Project_Manager_from_Schedule__c = True;
                      /*  if(schRecords.size() > 0){
                            if(schRecords[0].buildertek__Project_Manager__c != null){
                                project.buildertek__Project_Manager__c = schRecords[0].buildertek__Project_Manager__c;
                            }
                        }  */
                    System.debug('Check Project Manager');
                        project.buildertek__Milestone__c = true;
                        projectTasks.add(project);
                    }
                    
                }
            }
            System.debug('Project Task::' + projectTasks);
            
            insert projectTasks;
            futureContoller.updateScheduleRec(recordId);
          /*   List<buildertek__Project_Task__c> scheduleLinesListToUpdate = new  List<buildertek__Project_Task__c>();
            for(buildertek__Project_Task__c schedulesLines : projectTasks){
                if(schedulesLines.Name ==  'Milestone Complete'){
                     if(schRecords.size() > 0){
                            if(schRecords[0].buildertek__Project_Manager__c != null){
                                schedulesLines.buildertek__Project_Manager__c = schRecords[0].buildertek__Project_Manager__c;
                                 scheduleLinesListToUpdate.add(schedulesLines);
                            }
                        } 
                   }
                
            }
            if(!scheduleLinesListToUpdate.isEmpty()){
                update scheduleLinesListToUpdate;
            } */

        } else{
            system.debug('Error---');
            msg.Status = 'Failed';
            msg.Message = 'There are no schedule lines for the selected schedule.';
        }
        return msg;
    } catch (Exception e){
        msg.Status = 'Failed';
        msg.Message = e.getMessage();
        System.debug('Error::' + e.getMessage()+':Line:' + e.getLineNumber());
        return msg;
    }
}

public class MasterScheduleClass{
    @AuraEnabled
    public buildertek__Schedule__c masterscheduleRecord{ get; set; }

    @AuraEnabled
    public boolean scheduleCheck{ get; set; }
}

public class MessageClass{
    @AuraEnabled
    public String Status{ get; set; }

    @AuraEnabled
    public string Message{ get; set; }
}
}