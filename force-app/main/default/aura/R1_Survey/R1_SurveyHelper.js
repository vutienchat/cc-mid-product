({
    getQuestion : function(component, event){
        var action = component.get("c.getQuestion");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                component.set("v.listItem", result);
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getQuestion, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getQuestion, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
    
    getInforContact : function(component, event){
        var action = component.get("c.getInforContactDB");
        action.setParams({
            phone: component.get("v.phone")
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                component.set("v.name", result.Name);
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getQuestion, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getQuestion, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
})