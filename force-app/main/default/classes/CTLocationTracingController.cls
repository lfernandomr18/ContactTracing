public with sharing class CTLocationTracingController {
   
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Name, Person__r.Name, Location__r.Name, Visit_Date__c,Person__r.Health_Status__c
        FROM Location_Tracing__c 
        WHERE Location__c=: locationId
        AND Visit_Date__c = LAST_N_DAYS:30
        WITH SECURITY_ENFORCED 
        ORDER BY Visit_Date__c DESC];
    }
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Location__c, Visit_Date__c, Person__c, Id, Name,Person__r.Health_Status__c 
        FROM Location_Tracing__c 
        WHERE Person__c IN: personIds AND Visit_Date__c = LAST_N_DAYS:10
        WITH SECURITY_ENFORCED 
        ORDER BY Visit_Date__c DESC];
    }
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [SELECT Location__c, Visit_Date__c, Person__c, Id, Name,Person__r.Health_Status__c 
        FROM Location_Tracing__c 
        WHERE Location__c IN: locationIds AND Visit_Date__c > :(Date.Today()-10) AND Person__r.Health_Status__c='Green'
        WITH SECURITY_ENFORCED 
        ORDER BY Visit_Date__c DESC];
    }
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();
        for(Location_Tracing__c loctraces:newLocationTraces){
            locationIds.add(loctraces.Location__c);
            personIds.add(loctraces.Person__c);
        }  
        //query existing records using set previusly created
        List<Location_Tracing__c> existingRecords=[SELECT Location__c, Visit_Date__c, Person__c, Id, Name,Person__r.Health_Status__c 
        FROM Location_Tracing__c 
        WHERE Location__c IN: locationIds AND Person__c IN: personIds
        WITH SECURITY_ENFORCED ];
        //Map<Location__c,Set<Person__c> existingRecordsmap
        Map<Id, Set<Id>> existingRecordsmap = new Map<Id, Set<Id>>();
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        if(existingRecords!=null && existingRecords.size()>0){
            for(Location_Tracing__c trace:existingRecords){
                if(!existingRecordsmap.containsKey(trace.Location__c)){
                    existingRecordsmap.put(trace.Location__c,new Set<Id>());
                }
                //add person ids to the map set for currenly iteration
                existingRecordsmap.get(trace.Location__c).add(trace.Person__c);
            }
            //checking for duplicates comparing existingRecordsmap and  newLocationTraces if exist duplicate, we add to the duplicates List
            for(Location_Tracing__c trace:newLocationTraces){
                if(existingRecordsmap.containsKey(trace.Location__c) && existingRecordsmap.get(trace.Location__c).contains(trace.Person__c)){
                    duplicates.add(trace);
                }
            }    
        }
        return duplicates;      
    }
}