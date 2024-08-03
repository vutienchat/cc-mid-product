({
    doInit : function(component, event, helper) {
        var action = component.get("c.checkPermission");
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                 console.log('checkPermission');
                console.log(result);
                component.set("v.isProcess", result);
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
    
    onClick : function(component, event, helper) {
        if(component.get("v.reason") == undefined){
            helper.showToast(component, event); 
        }else{
            var action = component.get("c.createTask");
            action.setParams({
                recordId: component.get("v.recordId"),
                reason: component.get("v.reason")
            });
            action.setCallback(this, function(response){
                var state = response.getState();        
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log(result);
                    component.set("v.isProcess", true);
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
        }
    }
})