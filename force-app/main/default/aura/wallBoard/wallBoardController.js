({
    doInit: function(component, event, helper) {
        helper.callApexMethod(component, event,helper);
        helper.getWallboardReportInterval(component, event,helper);
        document.addEventListener('visibilitychange',()=>{
            if(document.hidden){
              window.clearInterval(component.get('v.intervalId'));
            }else{
            helper.getWallboardReportInterval(component, event,helper);
            }
          })
    },

    handleRefresh : function(component, event, helper) {
      helper.callApexMethod(component, event,helper);
    }
})