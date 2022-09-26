public class deleteRec {
    public static void deleterec(){
        buildertek__Quote__c[] d=[select id,buildertek__Status__c from buildertek__Quote__c where buildertek__Status__c='Draft'];
        delete d;
        System.debug('success');
    }
}