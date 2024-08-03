({
    doInit : function(component, event, helper) {
        var action = component.get("c.getShiftForAgent");
         action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){      
                var result = response.getReturnValue();
                if(result != null && result != '') {
                    console.log(result);
                    helper.checkTimeWithShift(component, result);
                }
            } else if(state === "INCOMPLETE"){   
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false);
            }
        });        
        $A.enqueueAction(action);
    }, 
    closeModal : function(component, event, helper) {
        component.set("v.isShowModal", false);
    }
})