({
	doInit : function(component, event, helper) {
		 var record = component.get("v.recordId");
        var action = component.get("c.handlerClockOutForAgent")
        action.setParams({
            'recordId' : record
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){      
                var result = response.getReturnValue();
                
                if(result == 'Thành công') {
                    component.set("v.isShowWarning", false);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                } else {
                   component.set("v.isShowWarning", true);
                } 
            } else if(state === "INCOMPLETE"){   
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false);
            }
        });        
        $A.enqueueAction(action);
	}
})