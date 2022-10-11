/*
Copyright (c) 2017-2018, BuilderTek.
All rights reserved.

Developed By: Sagar
Date: 24/05/2018
*/
trigger ProjectTaskTrigger on buildertek__Project_Task__c(after insert, after update, before delete, after delete, before insert, before update, After Undelete ){
    
    if (!BT_Utils.isTriggerDeactivate('Project_Task__c') && !ProjectTaskTriggerHandler.blnSkipTaskTrigger){
        ProjectTaskTriggerHandler handler = new ProjectTaskTriggerHandler(Trigger.isExecuting, Trigger.size);
        if (Trigger.isInsert){
            
            
            
            system.debug('insert'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
            if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                system.debug('insert1'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
                return;
            }
            system.debug('insertBefore0'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
            if (Trigger.isBefore){
                system.debug('insertBefore1'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
//                handler.OnBeforeInsert(Trigger.new);
                ProjectTaskTriggerHandler.OnBeforeInsert(JSON.serialize(Trigger.new));
                
            } else if(Trigger.isAfter){
                system.debug('test-----------------------------------------------------------------------------ProjectTaskTrigger 27');
                
                if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                    system.debug('insertStop------------->'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
                    
                }else{
                    //handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                    ProjectTaskTriggerHandler.updateChildDatesWithPredecessor(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                    system.debug('test2-----------------------------------------------------------------------------ProjectTaskTrigger 34');
                    
//                    handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                    ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
                    
                    //handler.OnAfterInsert(Trigger.new, Trigger.newMap);
                    ProjectTaskTriggerHandler.OnAfterInsert(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                    handler.UpdateOriginalstartandEndDates(Trigger.new, Trigger.newMap);
                    if (ProjectTaskTriggerHandler.isTask == true){
//                        handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                        ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
                        handler.OnBeforeInsert1(Trigger.new);
                        ProjectTaskTriggerHandler.isTask = false;
                    }
                    //insert update milestones
                    //handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                    ProjectTaskTriggerHandler.insertUpdateMilestones(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                }
                
                
                
                
                /*  handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);

handler.OnAfterInsert(Trigger.new, Trigger.newMap);
handler.UpdateOriginalstartandEndDates(Trigger.new, Trigger.newMap);
if (ProjectTaskTriggerHandler.isTask == true){
handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
handler.OnBeforeInsert1(Trigger.new);
ProjectTaskTriggerHandler.isTask = false;
}*/
                
                
            }
        } else if (Trigger.isUpdate){
            
            System.debug('After Update Call::'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
            if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                system.debug('update1'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
                return;
            }
            if (Trigger.isAfter){
                system.debug('test-----------------------------------------------------------------------------');
                
                //handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                ProjectTaskTriggerHandler.updateChildDatesWithPredecessor(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                
                system.debug('test2-----------------------------------------------------------------------------');
                
                
            }
            if (Trigger.isBefore){
                handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
            } else if (Trigger.isAfter){
                handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
                system.debug('test-2');
                handler.OnAfterUpdateOriginalstartandEndDates(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
                
                //handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                ProjectTaskTriggerHandler.insertUpdateMilestones(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
            }
            
            
            //insert update milestones
            
            
        }else if (Trigger.isDelete && Trigger.isAfter){
            
            //handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
            
            handler.OnAfterDelete(Trigger.old);
            
        }else if (Trigger.isUnDelete && Trigger.isAfter){
            
            //handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
        }
        
    }
    
}