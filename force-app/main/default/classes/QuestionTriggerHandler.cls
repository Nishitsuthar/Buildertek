/*
Copyright (c) 2017-2018, BuilderTek.
All rights reserved. 

Developed By: Sagar
Date:  20-Jul-2018
*/
public with sharing class QuestionTriggerHandler {
    //Boolean variable to allow skipping execution of trigger in certain scenarios
    public static Boolean blnSkipTrigger = false;
     
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public QuestionTriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Question__c[] newQuestions){
        
    }
     
    public void OnBeforeUpdate(Question__c[] oldQuestions, Question__c[] updatedQuestions, Map<ID, Question__c> QuestionsMap){
        
    }
     
    public void OnBeforeDelete(Question__c[] QuestionsToDelete, Map<ID, Question__c> QuestionsMap){
        
    }
     
    public void OnAfterInsert(Question__c[] newQuestions, Map<ID, Question__c> newQuestionsMap){ 
        
        // After insertion of quetion create question result
        List<Question_Result__c> results = new List<Question_Result__c>();
        Set<Id> selectionIds = new Set<Id>();
        for(Question__c q:newQuestions){
            if(Schema.sObjectType.Question_Result__c.fields.Selection_Category__c.isCreateable() && Schema.sObjectType.Question_Result__c.fields.Question__c.isCreateable()){
                Question_Result__c qr = new Question_Result__c();
                qr.Selection_Category__c = q.Section__c;
                qr.Question__c = q.Id;
                results.add(qr);
                
                selectionIds.add(q.Section__c);
            }
        }
        insert results;
        
        List<buildertek__Section__c> selection = new List<buildertek__Section__c>();
        if(Schema.sObjectType.buildertek__Section__c.fields.buildertek__Total_Options__c.isUpdateable()){
            for( buildertek__Section__c section :[Select Id,(Select Id from Questions__r), buildertek__Total_Options__c from buildertek__Section__c where Id IN:selectionIds]){
                section.buildertek__Total_Options__c = section.Questions__r.size();
                selection.add(section);
            }
        }
        if(!selection.isEmpty()) {
            update selection;
        }
        
    }
     
    public void OnAfterUpdate(Question__c[] oldQuestions, Question__c[] updatedQuestions, Map<ID, Question__c> QuestionsMap, Map<Id, Question__c> oldQuestionsMap){

        

    }
    
    public void OnBeforeUpdate(Question__c[] newQuestions, Map<ID, Question__c> newQuestionsMap){
     
    }
    
    public void OnAfterDelete(Question__c[] oldQuestions){
        
        Set<Id> selectionIds = new Set<Id>();
        for(Question__c q:oldQuestions){
            selectionIds.add(q.Section__c);
        } 
        
        List<buildertek__Section__c> selection = new List<buildertek__Section__c>();
        if(Schema.sObjectType.buildertek__Section__c.fields.buildertek__Total_Options__c.isUpdateable()){
            for( buildertek__Section__c section :[Select Id,(Select Id from Questions__r), buildertek__Total_Options__c from buildertek__Section__c where Id IN:selectionIds]){
                section.buildertek__Total_Options__c = section.Questions__r.size();
                selection.add(section);
            }
        }
        if(!selection.isEmpty()) {
            update selection;
        }
    }
}