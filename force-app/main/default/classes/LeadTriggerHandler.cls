public with sharing class LeadTriggerHandler {

    public static void beforeInsertHandler(List<Lead> newRecords){
        for(Lead leadtrigger: newRecords){
            if(String.isBlank(leadtrigger.LeadSource) ){
                leadtrigger.LeadSource ='Other';
            }  
            if(String.isBlank(leadtrigger.Industry)){
                leadtrigger.addError('The industry field cannot be blank');
            }
        }

    }
    public static void afterInsertHandler(List<Lead> newRecords){
        List<Task> leadTasks = new List<Task>();
            for(Lead leadtrigger: newRecords){
                Task leadTask= new Task(Subject='Follow up on Lead Status',WhoId=leadtrigger.Id);
                leadTasks.add(leadTask);
            }
            insert leadTasks;

    }
    public static void beforeUpdateHandler(List<Lead> newRecords,Map<Id,Lead> oldRecordsMap){
        for(Lead leadtrigger: newRecords){
            if((leadtrigger.Status=='Closed - Converted'||leadtrigger.Status=='Closed - Not Converted')&& oldRecordsMap.get(leadtrigger.Id).Status=='Open - Not Contacted'){
                leadtrigger.Status.addError('You cannot directly close an open lead record');
            }
        }
    }
    
}