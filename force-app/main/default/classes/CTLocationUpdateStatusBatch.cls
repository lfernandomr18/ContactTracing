public with sharing class CTLocationUpdateStatusBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        Date today= Date.today();
        Date fourteenDaysAgo= today-14;
        List<String> healthStatuses= new List<String>{ 'Red','Orange','Yellow'};
        return Database.getQueryLocator('SELECT Id FROM Location__c WHERE Status_Update_Date__c= :fourteenDaysAgo AND Status__c  IN : healthStatuses');
    }

    public void execute(Database.BatchableContext bc,List<Location__c> scope){
        for (Location__c p : scope) {
         p.Status__c  ='Green';  
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Batch is complete');
    }
}
