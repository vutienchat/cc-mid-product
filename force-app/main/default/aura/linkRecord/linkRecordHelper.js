({
    helperMethod : function() {

    },

    callApexMethod : function (component,event,helper){
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.getCallId");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                console.log('result.Call_ID__c cc',result.Call_ID__c)
                const value = result.Call_ID__c;
                component.set('v.callId', value);
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getCallIdDB, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getCallIdDB, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    } 
})