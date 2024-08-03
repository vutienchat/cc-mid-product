({
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Vui lòng nhập lý do"
        });
        toastEvent.fire();
    }
})