public with sharing class CTHealthHeaderController {
    @AuraEnabled
    public static List<AggregateResult> getPersonHealthStatusCount(){
        List<AggregateResult> personCountHS= [SELECT Count(Id) personCount,Health_Status__c FROM Person__c GROUP BY Health_Status__c];
        return personCountHS;
    }
    @AuraEnabled
    public static List<AggregateResult> getLocationHealthStatusCount(){
        List<AggregateResult> LocationCountHS=[SELECT Count(Id)LocationCount,Status__c  FROM Location__c GROUP BY Status__c];
        return LocationCountHS;
    }

   
}
