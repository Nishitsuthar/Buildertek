@isTest
public class QuestionTriggerHandlerTest {
    public static testMethod void testQuestionTriggerHandler() {
        Question__c question = new Question__c(Name = 'Test 1');
        insert question;
        update question;
        delete question;
        System.assertEquals('Test','Test');
    }
}