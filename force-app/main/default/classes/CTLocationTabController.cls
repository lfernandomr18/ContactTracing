public with sharing class CTLocationTabController {
    @AuraEnabled 
    public static LocationInformation getLocationDetails(String recordId) {
        LocationInformation info= new LocationInformation();
        Location__c location = CTLocationController.getLocationById(recordId);
        if(location != null){
            info.Name=location.Name;
            info.Address=location.Address__c;
            info.Pincode=location.Pincode__c;
            info.Red_Score=location.Red_Score__c;
            info.StatusUpdateDate=location.Status_Update_Date__c;   
            info.Status=location.Status__c; 
        }
        List<Location_Tracing__c> traces= CTLocationTracingController.getVisitors(recordId);
        if(traces !=null && traces.size() >0){
            List<Visitors> visitors= new List<Visitors>();
            for (Location_Tracing__c trace : traces) {
                Visitors vs= new Visitors();
                vs.id = trace.Id;
                vs.Name = trace.Name;
                vs.PersonName = trace.Person__r.Name;
                vs.LocationName = trace.Location__r.Name;
                vs.VisitDate = trace.Visit_Date__c;
                vs.PersonHealthStatus = trace.Person__r.Health_Status__c;
                visitors.add(vs);
            }
            info.visitors = visitors;
            info.visitorsCount = visitors.size();
        }
        return info;
   }
   public class LocationInformation{
    @AuraEnabled public String Name;
    @AuraEnabled public String Address;
    @AuraEnabled public String Pincode;
    @AuraEnabled public Double Red_Score;
    @AuraEnabled public Date StatusUpdateDate;
    @AuraEnabled public String Status;
    @AuraEnabled public Integer visitorsCount=0;
    @AuraEnabled public List<Visitors> visitors;
   }
   public class Visitors{
    @AuraEnabled public String id;
    @AuraEnabled public String Name;
    @AuraEnabled public String PersonName;
    @AuraEnabled public String LocationName;
    @AuraEnabled public Date VisitDate;
    @AuraEnabled public String PersonHealthStatus;
   }
}


