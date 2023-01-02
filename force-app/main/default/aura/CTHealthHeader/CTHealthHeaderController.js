({
    createRecord : function (component, event, helper) {
        const selectedTabValue=component.get("v.pageHeaderTitle");
        let entityApiName="";
        if(selectedTabValue=="Person View"){
            entityApiName="Person__c";
        }
        else{
            entityApiName="Location__c";
        }
        console.log(selectedTabValue);
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": entityApiName
        });
        createRecordEvent.fire();
    },
    tabSelectedHandler : function(component,event,helper){
        helper.clearheader(component);
        const selectedTab = event.getParam("selectedTab");
        // create apex method call action
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
                if(selectedTab=="person_view"){
                    for (let index = 0; index < resp.length; index++) {
                        if(resp[index].Health_Status__c=="Green"){
                            component.set("v.green",resp[index].personCount);
                        }
                        else if(resp[index].Health_Status__c=="Yellow"){
                            component.set("v.yellow",resp[index].personCount);
                        }
                        else if(resp[index].Health_Status__c=="Orange"){
                            component.set("v.orange",resp[index].personCount);
                        }
                        else{
                            component.set("v.red",resp[index].personCount);
                        }  
                    }

                }
                else{ 
                    for (let index = 0; index < resp.length; index++) {
                        if(resp[index].Status__c=="Green"){
                            component.set("v.green",resp[index].LocationCount);
                        }
                        else if(resp[index].Status__c=="Yellow"){
                            component.set("v.yellow",resp[index].LocationCount);
                        }
                        else if(resp[index].Status__c=="Orange"){
                            component.set("v.orange",resp[index].LocationCount);
                        }
                        else{
                            component.set("v.red",resp[index].LocationCount);
                        }  
                    }
                }
               
                
                console.log(resp);
            }
        });
        $A.enqueueAction(action);
        
    }
})





