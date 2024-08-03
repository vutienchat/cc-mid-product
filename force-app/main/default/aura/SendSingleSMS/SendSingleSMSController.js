/* * @description       : The Class for Log
* @author            : DTDuong - GMS
* @last modified on  : 2024.04.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
* */
({
	doInit : function(component, event, helper) {
		// helper.getPers(component, event, helper);
        helper.getTemp(component, event, helper);
	},
    callSendSMS : function(component, event, helper) {
        var content = component.get("v.smsContent");
        if(content != null && content != ''){
            helper.sendSmsHelper(component, event, helper);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "duration": 30000,
                "title": "ERROR",
                "message": "Nội dung sms không thể bỏ trống.",
                "type": "ERROR"
            }); toastEvent.fire();
        }
    },
    handleChangeTemplate : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        if(selectedOptionValue!= null && selectedOptionValue != ''){
            var action = component.get("c.get_SMS_body");
            action.setParams({
                'recordId': component.get("{!v.recordId}"),
                'templateName': selectedOptionValue
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    if(storeResponse.body_SMS != null){
                        component.set("v.smsContentTemplate", storeResponse.body_SMS);
                        component.set("v.smsContent", storeResponse.body_SMS);
                    }
                    helper.changeContent(component, event, helper); 
                }
            });
            $A.enqueueAction(action); 
        } 
    },
    
    handleChangeContent : function(component, event, helper) {
        helper.changeContent(component, event, helper); 
    },
    
    cancel : function(component, event, helper) {
        component.set("v.smsContent", '');
    }
})