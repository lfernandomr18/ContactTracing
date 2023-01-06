public with sharing class CTPersonViewController {
    
    @AuraEnabled
    public static void updateHealthStatus(String recordId){
        CTPersonController.updateHealthStatusToRed(recordId);
    }
}
