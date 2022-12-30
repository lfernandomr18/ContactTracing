public with sharing class ContactTriggerHandler {
    public static void updateActiveContactNumber(List<Contact> newRecords){
        Set<Id> accountsToQuery= new Set<Id>();
        List<Account> accountstoUpdate = new  List<Account>();
        Map<Id,Integer> maptoupdate = new Map<Id,Integer>();
        for(Contact c :newRecords){   
            accountsToQuery.add(c.AccountId);
        }
        if(accountsToQuery !=null || accountsToQuery.size()!=0){
            for(Contact con : [SELECT AccountId, Active__c FROM Contact WHERE accountId IN: accountsToQuery]){
                if(!maptoupdate.containsKey(con.AccountId)){
                    maptoupdate.put(con.AccountId, 0);
                }
                if(con.Active__c==true){
                    maptoupdate.put(con.AccountId, (maptoupdate.get(con.AccountId))+1);
                }
            }
            for (Id key : maptoupdate.keySet()) {
                AccountstoUpdate.add(new Account(Id=String.valueOf(key),Active_Contacts__c=Integer.valueOf(maptoupdate.get(key))));
            }
            update accountstoUpdate;
        }        
    }
}