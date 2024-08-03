/**
* @description       : The Class for Log
* @author            : DTDuong - GMS
* @last modified on  : 2024.04.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

({
    showToast : function(component, event, helper) {
                
        var params = event.getParam( 'arguments' );  
        try {
            if(component.get("v.customTimeToastClose") == true){
                component.set("v.message", params.message);
                component.set("v.messageType", params.messageType);
                
                $A.util.removeClass( component.find( 'toastModel' ), 'slds-hide' );
                $A.util.addClass( component.find( 'toastModel' ), 'slds-show' );
                
                var closeTime =  component.get("v.autoCloseTime");
                var autoClose =  component.get("v.autoClose");
                var autoCloseErrorWarning =  component.get("v.autoCloseErrorWarning");
                
                if(autoClose)
                    if( (autoCloseErrorWarning && params.messageType != 'success') || params.messageType == 'success') {
                        setTimeout(function(){ 
                            $A.util.addClass( component.find( 'toastModel' ), 'slds-hide' ); 
                            component.set("v.message", "");
                            component.set("v.messageType", "");
                        }, closeTime);
                    }
            } else {
                component.find('notifLib').showToast({
                    "variant": params.messageType,
                    "message": params.message,
                    "mode": "dismissable"
                });
            }
          
        }
        catch(err) {
            component.set("v.message", params.message);
            component.set("v.messageType", params.messageType);
            
            $A.util.removeClass( component.find( 'toastModel' ), 'slds-hide' );
            $A.util.addClass( component.find( 'toastModel' ), 'slds-show' );
            
            var closeTime =  component.get("v.autoCloseTime");
            var autoClose =  component.get("v.autoClose");
            var autoCloseErrorWarning =  component.get("v.autoCloseErrorWarning");
            
            if(autoClose)
                if( (autoCloseErrorWarning && params.messageType != 'success') || params.messageType == 'success') {
                setTimeout(function(){ 
                    $A.util.addClass( component.find( 'toastModel' ), 'slds-hide' ); 
                    component.set("v.message", "");
                    component.set("v.messageType", "");
                }, closeTime);
            }
        }
       
	},
    
	closeModel : function(component, event, helper) {
        var messageType = component.get("v.messageType");
        if(messageType == 'success'){
            var cmpEventSmsMassClose = component.getEvent("cmpEventSmsMassClose");
            if(cmpEventSmsMassClose){
                cmpEventSmsMassClose.fire();
            }
            var cmpEventSmsSingleClose = component.getEvent("cmpEventSmsSingleClose");
            if(cmpEventSmsSingleClose){
                cmpEventSmsSingleClose.fire();
            }
        }
        
		$A.util.addClass( component.find( 'toastModel' ), 'slds-hide' );
        component.set("v.message", "");
        component.set("v.messageType", "");
        
	}
})