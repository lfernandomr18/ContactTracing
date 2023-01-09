public with sharing class CTLocationTracingDataCleanupBatch  implements Database.Batchable<SObject> {

    
        public Database.QueryLocator start(Database.BatchableContext bc){
             return Database.getQueryLocator('SELECT Id FROM Location_tracing__c WHERE Visit_Date__c< LAST_N_DAYS : 30');
        }
    
        public void execute(Database.BatchableContext bc,List<Location_tracing__c> scope){
            delete scope;
        }
    
        public void finish(Database.BatchableContext bc){
            System.debug('Batch is complete');
        }
    
    
}
