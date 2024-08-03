({
    doInit : function(component, event, helper) {
        var action = component.get("c.getOpp");
        var recordId = component.get("v.recordId"); 

        action.setParams({
            'recordId': recordId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.opportunityWrapper", result);
                console.log('getOpp success!');
                setTimeout(function() {
                    $A.get('e.force:refreshView').fire();
                    }, 2500);
            } else {
                console.log("Error!");
            }
        });
        $A.enqueueAction(action);
    },
    closeModal: function(component, event, helper) {
        // Close the modal
        var closeEvent = $A.get("e.force:closeQuickAction");
        setTimeout(function() {
        	$A.get('e.force:refreshView').fire();
        }, 2500);
        closeEvent.fire();
    }
    
})