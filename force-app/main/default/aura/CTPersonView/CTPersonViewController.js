({
    eventHandler : function(component, event, helper) {
        const recordId= event.getParam("recordId");
        const status= event.getParam("status");
        component.set("v.recordId",recordId);
        component.set("v.status",status);

        if(status !='Red'){
            component.set("v.isNotRed",true);
        }
        else{component.set("v.isNotRed",false);}

    },
    handleClick : function (cmp, event, helper) {
       var action = cmp.get("c.updateHealthStatus");
       var recordId= cmp.get("v.recordId");
        
        
        action.setParams({ recordId : recordId});
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showToast("Success","Person Health Status Updated","success");
                cmp.set("v.status","Red");
                cmp.set("v.isNotRed",false);
            } 
        }));
        $A.enqueueAction(action);
    }
})
