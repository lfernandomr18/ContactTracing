public with sharing class CTPersonTriggerHandler {
   
    public static void beforeInsertPerson(List<Person__c> newRecords){

        for(Person__c person : newRecords){
            person.Health_Status__c='Green';
            person.Token__c=CTPersonController.getToken(person.Mobile__c );
            
        }

    }
    public static void beforeUpdatePerson(List<Person__c> newRecords,Map<Id,Person__c> mapOldRecords){

        
        for(Person__c person : newRecords){
            if(person.Health_Status__c != mapOldRecords.get(person.ID).Health_Status__c){
                person.Status_Update_Date__c =Date.today();
            }
        }

    }
    public static void afterUpdatePerson(List<Person__c> newRecords,Map<Id,Person__c> mapOldRecords){
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        for(Person__c person : newRecords){
            if(person.Health_Status__c != mapOldRecords.get(person.ID).Health_Status__c){
                statusChange.add(person.Id);
            }
            if(person.Health_Status__c=='Red' && mapOldRecords.get(person.ID).Health_Status__c!='Red'){
                redStatus.add(person.Id);
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);
        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        
        List<Person__c> personToUpdate = new  List<Person__c>();
        System.debug(redStatus);
        //lets add cohabitants
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus,alreadyProcessed)) ;
        //lets add primaryContacts
        Set<Id> primaryContacts= CTPersonController.getPrimaryContact(redStatus,alreadyProcessed);
        orangeStatus.addAll(primaryContacts) ;
        //lets add neighbours
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus,alreadyProcessed)) ;
        //lets add secondaryContacts
        yellowStatus.addAll(CTPersonController.getSecondaryContacs(primaryContacts,alreadyProcessed)) ;
        System.debug(orangeStatus);
        System.debug(yellowStatus);
        for (Id pid : orangeStatus) {
            personToUpdate.add(new Person__c(Id=pid,Health_Status__c='Orange'));   
        }
        for (Id pid : yellowStatus) {
            personToUpdate.add(new Person__c(Id=pid,Health_Status__c='Yellow'));   
        }
        if (personToUpdate.size() > 0) {
            System.debug(personToUpdate);
            update personToUpdate;
        }
        System.debug('statusChange'+statusChange);
        List<Location_Tracing__c> locationTraces=CTLocationTracingController.getLocationsByPersonIds(statusChange);
        System.debug('locationTraces'+locationTraces);
        if(locationTraces !=null && locationTraces.size()>0){
            Set<Id> locationIds=new Set<Id>();
            for (Location_Tracing__c trace : locationTraces) {
                locationIds.add(trace.Location__c);
            }
            CTLocationController.updateRedScore(locationIds);
        }

    }




}