({
    doInit: function(cmp) {
        // var clickToDialService = cmp.find("clickToDialService");
        // clickToDialService.enable();
        // clickToDialService.addDialListener(function(payload){
        //     const phoneNumber =payload.number
        //     let event = new CustomEvent('clickToCall',{
        //         detail:{
        //           value:phoneNumber
        //         },
        //       });
        //       window.dispatchEvent(event);
        // });
    },

    onOpenPhoneBar : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.getUtilityInfo().then(function(response) {
           if (!response.utilityVisible) {
               utilityAPI.openUtility();
           }
        })
        .catch(function(error) {
         console.log(error);
        });
    },

    onExpand : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.setPanelWidth({
            widthPX: 900
        });
        component.set('v.isExpand', true);
    },

    onCollapse : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.setPanelWidth({
            widthPX: 350
        });
        component.set('v.isExpand', false);
    },

})