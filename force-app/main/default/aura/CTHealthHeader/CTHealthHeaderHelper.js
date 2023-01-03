({
    clearheader : function(component,event,helper){
        component.set("v.green","0");
        component.set("v.yellow","0");
        component.set("v.orange","0");
        component.set("v.red","0");
        
    },
    assignValuesToHeader : function(component,resp,selectedTab){
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
    }
})
