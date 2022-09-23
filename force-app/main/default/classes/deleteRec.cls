public class deleteRec {
    public static void deleterec(){
        buildertek__Quote_Item__c[] d=[select id,Name from buildertek__Quote_Item__c where Name='Check Opportunity 24" coil'];
        delete d;
        System.debug('success');
    }
}