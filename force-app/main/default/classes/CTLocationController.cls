public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c 
        WITH SECURITY_ENFORCED 
        ORDER BY Status_Update_Date__c DESC 
        LIMIT 100 ];
        
    }
    public static List<Location__c> searchLocations(String searchTerm){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c 
        WHERE Name LIKE :'%'+searchTerm+'%' OR  Pincode__c LIKE :'%'+searchTerm+'%' OR Address__c LIKE :'%'+searchTerm+'%' 
        WITH SECURITY_ENFORCED 
        ORDER BY Status_Update_Date__c DESC 
        LIMIT 100 ];
        
    }
    public static Location__c getLocationById(String locationId){
        List<Location__c> locations =[SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c 
        WHERE Id=:locationId 
        WITH SECURITY_ENFORCED 
         ];
        if(locations !=null && locations.size() >0){
            return locations[0];
        }
        else {
            return null;
        }      
    }

    public static Map<String,Integer> getStatusCount(){
        Map<String,Integer> mapQuery= new Map<String,Integer>();
        for(AggregateResult loc:[SELECT Status__c healthStatus ,COUNT(Id) numberofLocations 
        FROM Location__c 
        WITH SECURITY_ENFORCED 
        GROUP BY Status__c ]){
            mapQuery.put(String.valueOf(loc.get('healthStatus')), Integer.valueOf(loc.get('numberofLocations'))); 
        }
        return mapQuery;
    }

    public static void updateRedScore(Set<Id> locationIds){
        List<Location__c> locationToUpdate =new List<Location__c>();
       AggregateResult[] redPeoplePerLocation= [
            SELECT Location__c ,COUNT(Id) total
            FROM Location_Tracing__c
            WHERE Person__r.Health_Status__c='Red'
            AND Visit_Date__c = LAST_N_DAYS :10
            AND Location__c IN : locationIds
            GROUP BY Location__c
        ];

        for (AggregateResult ar : redPeoplePerLocation) {
            String LocationID=String.valueOf(ar.get('Location__c'));
            Integer redScore=Integer.valueOf(ar.get('total'));
            String status=getStatus(redScore);
            locationToUpdate.add(new Location__c(Id=LocationID,Red_Score__c=redScore,Status__c=status));
        }
        System.debug(''+locationToUpdate);
        if(locationToUpdate != null && locationToUpdate.size()>0){
            update locationToUpdate;
        }
    }

    public static String getStatus(Integer redScore){
        if(redScore==0){
            return 'Green';
        }
        else if(redScore<=5) {
            return 'Yellow';
        }
        else if(redScore<=10) {
            return 'Orange';
        }
        else {
            return 'Red';
        }
    }
}