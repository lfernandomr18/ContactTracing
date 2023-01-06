({
    init : function(cmp, event, helper) {
        const selectedTab = cmp.get("v.selectedTab");
        if(selectedTab=="person_view"){
            cmp.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Phone', fieldName: 'Mobile__c', type: 'text'},
                {label: 'Token', fieldName: 'Token__c', type: 'text'},
                {label: 'Status', fieldName: 'Health_Status__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ]);
        }
        else{
            cmp.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Adress', fieldName: 'Address__c', type: 'text'},
                {label: 'Pin Code', fieldName: 'Pincode__c', type: 'text'},
                {label: 'Red Score', fieldName: 'Red_Score__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ]);
        }
        helper.getData(cmp,selectedTab);

    },
    handleKeyUp: function (cmp, evt,helper) {
        const selectedTab = cmp.get("v.selectedTab");
        var isEnterKey = evt.keyCode === 13;
        var queryTerm = cmp.find('enter-search').get('v.value');
        if(!queryTerm){
            helper.getData(cmp,selectedTab);
        }
        if (isEnterKey) {
            helper.searchData(cmp,selectedTab,queryTerm);  
        }
    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        const selectedTab = cmp.get("v.selectedTab");
        var appEvent =null;
        switch (action.name) {
            case 'view_details':
                if(selectedTab == "person_view" ){
                    appEvent = $A.get("e.c:CTPersonSelectEvent");
                    
                    var status=row.Health_Status__c;
                }
                else{
                    appEvent = $A.get("e.c:CTLocationSelectEvent");
                    var status=row.Status__c;
                }
                
                appEvent.setParams({
                    recordId : row.Id,
                    status : status
                })
                appEvent.fire();
                break;
            
        }
    }   
})


