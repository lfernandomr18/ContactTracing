({
    init : function(cmp, event, helper) {
        const selectedTab = cmp.get("v.selectedTab");
        if(selectedTab=="person_view"){
            cmp.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Phone', fieldName: 'Mobile__c', type: 'text'},
                {label: 'Token', fieldName: 'Token__c', type: 'text'},
                {label: 'Status', fieldName: 'Health_Status__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'}
            ]);
        }
        else{
            cmp.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Adress', fieldName: 'Address__c', type: 'text'},
                {label: 'Pin Code', fieldName: 'Pincode__c', type: 'text'},
                {label: 'Red Score', fieldName: 'Red_Score__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'}
            ]);
        }
        helper.getData(cmp,selectedTab);

    },
    handleKeyUp: function (cmp, evt) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = cmp.find('enter-search').get('v.value');
            alert('Searched for "' + queryTerm + '"!');
        }
    }   
})


