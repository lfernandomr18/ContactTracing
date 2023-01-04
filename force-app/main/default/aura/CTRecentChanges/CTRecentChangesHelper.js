({
    getData : function(cmp,selectedTab) {
        if(selectedTab=="person_view"){var action = cmp.get('c.getRecentPersonHealthChanges');}
        else{var action = cmp.get('c.getRecentLocationHealthChanges');}
        
        
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.data', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})
