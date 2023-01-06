public with sharing class CTPersonController {
    

    public  static String getToken(String mobile){
        Blob mobileBlob = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', mobileBlob);
        return  EncodingUtil.base64Encode(hash);
    }
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name,  Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c 
        WITH SECURITY_ENFORCED
        ORDER BY Status_Update_Date__c DESC 
        LIMIT 100];
        
    }
    public static List<Person__c> searchPeople(String searchTerm){
        return [SELECT Id, Name,  Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c 
        WHERE Name LIKE :'%'+searchTerm+'%' OR  Mobile__c LIKE :'%'+searchTerm+'%' OR Token__c LIKE :'%'+searchTerm+'%' 
        WITH SECURITY_ENFORCED
        ORDER BY Status_Update_Date__c DESC 
        ];
    }
    public static Person__c getPersonById(String personId){
        List<Person__c> people =[SELECT Id, Name,  Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c 
        WHERE Id=:personId
        WITH SECURITY_ENFORCED  
         ];
        if(people !=null && people.size() >0){
            return people[0];
        }
        else {
            return null;
        }
    }
    public static Map<String,Integer> getHealthStatusCount(){
        Map<String,Integer> mapQuery= new Map<String,Integer>();
        for(AggregateResult ppl:[SELECT Health_Status__c healthStatus,COUNT(Id) numberofPeople 
        FROM Person__c 
        WITH SECURITY_ENFORCED
        GROUP BY Health_Status__c ]){
            mapQuery.put(String.valueOf(ppl.get('healthStatus')), Integer.valueOf(ppl.get('numberofPeople')));   
        }
        return mapQuery;
    }
    public static Set<Id> getCohabitants(Set<Id> personIds,Set<Id> alreadyProcessed){
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Cohabitant'
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN : healthStatuses)];
        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                cohabitants.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!personIds.contains(pt.Person_2__c)){
                cohabitants.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return cohabitants;

    }
    public static Set<Id> getNeighbours(Set<Id> personIds,Set<Id> alreadyProcessed){
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Neighbour'
                                                    AND (Person_1__r.Health_Status__c ='Green' OR Person_2__r.Health_Status__c ='Green' )];
        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!personIds.contains(pt.Person_2__c)){
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return neighbours;
    }

    public static Set<Id> getPrimaryContact(Set<Id> personIds,Set<Id> alreadyProcessed){
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c= LAST_N_DAYS:10
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses )];
        Set<Id> primaryContacs = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                primaryContacs.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!personIds.contains(pt.Person_2__c)){
                primaryContacs.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return primaryContacs;
    }
    public static Set<Id> getSecondaryContacs(Set<Id> primaryContactsIds,Set<Id> alreadyProcessed){  
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :primaryContactsIds OR Person_2__c IN :primaryContactsIds) 
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c= LAST_N_DAYS:10
                                                    AND (Person_1__r.Health_Status__c ='Green' OR Person_2__r.Health_Status__c ='Green' )];
        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                secondaryContacts.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!primaryContactsIds.contains(pt.Person_2__c)){
                secondaryContacts.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return secondaryContacts;
    }
    public static void updateHealthStatusToRed(String recordId){
        Person__c person = [SELECT Id, Health_Status__c FROM Person__c WHERE Id = :recordId];
        person.Health_Status__c = 'Red';
        List<Person__c> personToUpdate = new List<Person__c>();
        personToUpdate.add(person);
        update personToUpdate;

    }
    
}