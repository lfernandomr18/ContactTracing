public with sharing class CTPeopleTracingController {
  
    public static List<People_Tracing__c> getTraces(String personId) {
        return [
            SELECT Id, Contact_Date__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c
            FROM People_Tracing__c
            WHERE (Person_1__c = :personId OR Person_2__c = :personId) AND Contact_Date__c = LAST_N_DAYS:30
            ORDER BY Contact_Date__c DESC
        ];
    }
   public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces){
    Set<Id> peopleIds=new Set<Id>();
    
    for(People_Tracing__c traces :newPeopleTraces){
        peopleIds.add(traces.Person_1__c);
        peopleIds.add(traces.Person_2__c);
    }
    Map<Id,Set<Id>> existingRecordsMap = new Map<Id,Set<Id>>();
    List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
    List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c 
    FROM People_Tracing__c 
    WHERE Person_1__c IN :peopleIds OR Person_2__c IN :peopleIds
    WITH SECURITY_ENFORCED];

    
    if(existingRecords != null && existingRecords.size() > 0){

        for(People_Tracing__c trace:existingRecords){
            if(!existingRecordsMap.containsKey(trace.Person_1__c)){
                existingRecordsMap.put(trace.Person_1__c, new Set<Id>());
            }
            existingRecordsMap.get(trace.Person_1__c).add(trace.Person_2__c);
            if(!existingRecordsMap.containsKey(trace.Person_2__c)){
                existingRecordsMap.put(trace.Person_2__c, new Set<Id>());
            }
            existingRecordsMap.get(trace.Person_2__c).add(trace.Person_1__c);
        }
        for(People_Tracing__c traces:newPeopleTraces){
            if(existingRecordsMap.containsKey(traces.Person_1__c) && existingRecordsMap.get(traces.Person_1__c).contains(traces.Person_2__c)
            ||
            existingRecordsMap.containsKey(traces.Person_2__c) && existingRecordsMap.get(traces.Person_2__c).contains(traces.Person_1__c)){
                duplicates.add(traces);
            }
        }
    }
    return duplicates;

   }
  
}