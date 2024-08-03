({
	getTask : function(component, event){
        console.log('')
        var recordId = component.get("v.recordId");
                
        var action = component.get("c.getTaskDB");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                component.set("v.phoneNumber", result.Phone__c);
                var phoneNumber = result.Phone__c;
                
                console.log(phoneNumber);
                
                var clickToDialService = component.find("clickToDialService");
                
                clickToDialService.enable();
                
                console.log(phoneNumber);
                let event = new CustomEvent('clickToCall',{
                    detail:{
                        value:phoneNumber
                    },
                });
                window.dispatchEvent(event);
                
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getTask, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getTask, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
})