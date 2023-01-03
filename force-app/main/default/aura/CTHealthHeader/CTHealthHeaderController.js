({
    createRecord : function (component) {
        const selectedTabValue=component.get("v.pageHeaderTitle");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": selectedTabValue =="Person View" ? "Person__c": "Location__c"
        });
        createRecordEvent.fire();
    },
    tabSelectedHandler : function(component,event,helper){
        //clearea los header a 0
        helper.clearheader(component);
        //obtiene el tab del evento tabSelectedEvent
        const selectedTab = event.getParam("selectedTab");
        // create apex method call action depending on tab selection
        let action=null;
        if(selectedTab=="person_view"){
           action = component.get("c.getPersonHealthStatusCount");
        }
        else{ 
           action = component.get("c.getLocationHealthStatusCount"); 
        }
        //define a callback
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === 'SUCCESS') {
                const resp = response.getReturnValue();
                helper.assignValuesToHeader(component,resp,selectedTab);
            }
        });
        $A.enqueueAction(action);
        
    }
})





