({
    init : function(cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Mobile__c', type: 'text'},
            {label: 'Token', fieldName: 'Token__c', type: 'text'},
            {label: 'Status', fieldName: 'Health_Status__c', type: 'text'},
            {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'}
        ]);
        helper.getData(cmp);

    },
    handleKeyUp: function (cmp, evt) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = cmp.find('enter-search').get('v.value');
            alert('Searched for "' + queryTerm + '"!');
        }
    }
})
