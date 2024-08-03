({
	doInit : function(component, event, helper) {
        var action = component.get("c.getPhone");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                component.set("v.phone", result);
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data createTask, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data createTask, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
    
    handleClick : function(component, event, helper) {
        navigator.clipboard.writeText(component.get("v.phone"));
    }
})