({
    doInit: function(component) {
        const listener = function(payload) {
            if(payload.number){
                component.find("phonecmp").getElement().handleMakeCall(payload)
            }
        };
        // Register the listener.
         sforce.opencti.onClickToDial({listener: listener});

        //  sforce.opencti.getSoftphoneLayout({
        //     callback: (response) =>{
        //         if (response.success) {
        //             console.log('getSoftphoneLayout',response.returnValue);
        //         } else {
        //            console.error(response.errors);
        //         }
        //      }
        //  });
    },

    showToast : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            'url': 'http://www.myurl.com'
        });
        urlEvent.fire();
    },
    // Aura component controller
    handleMessage: function(component, event, helper) {
        var message = event.getParam("message");
        var variant = event.getParam("variant");

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Toast!",
            "message": message,
            "type": variant
        });
        toastEvent.fire();
    },

    onOpenPhoneBar : function(component, event, helper) {
        sforce.opencti.isSoftphonePanelVisible({callback: function(response) {
            if (response.success) {
                !response.returnValue.visible && sforce.opencti.setSoftphonePanelVisibility({visible: true})
            } else { 
               sforce.opencti.setSoftphonePanelVisibility({visible: true})
            } 
         }});
    },

    onExpand : function(component, event, helper) {
        sforce.opencti.setSoftphonePanelWidth({widthPX: 900, callback: (response)=> {
            if (response.success) {
               component.set('v.isExpand', true);
            } 
         }});
    },

    navigateTo : function(component, event, helper) {
        const passedFunction = component.get("v.screenPop");
        const id = event.getParam('id');
        id && passedFunction(id)
    },
    
    onCollapse : function(component, event, helper) {
        sforce.opencti.setSoftphonePanelWidth({widthPX: 330, callback: (response)=> {
            if (response.success) {
               component.set('v.isExpand', false);
            }
         }});
    },

    disableClickToDial : function(component, event, helper) {
        sforce.opencti.disableClickToDial({callback:(response)=>{
            if(response.success){
                component.set('v.isEnableClickToDial',false)
            }
        }});
    },

    enableClickToDial : function(component, event, helper) {
        sforce.opencti.enableClickToDial({callback:(response)=>{
            if(response.success){
                component.set('v.isEnableClickToDial',true)
            }
        }});
    },

})