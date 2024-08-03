({
    getWallboardReportInterval: function(component, event, helper){
        
         var intervalId = window.setInterval(
             $A.getCallback(function() { 
                 // Calling Apex Method
                 helper.callApexMethod(component, event, helper);
             }), 1000*30);  
         component.set('v.intervalId', intervalId);
     },

    callApexMethod : function (component,event,helper){
        component.set('v.loading',true)
        var action = component.get("c.getWallboardReport");
        var now = new Date();
        const thirtyMinutesAgo = new Date(now.getTime() - (1000*60*30));
        if(action){
            action.setParams({ 
               fromTime : thirtyMinutesAgo.toISOString(),
               toTime : now.toISOString()
             });
            action.setCallback(this,function(response){
                var state = response.getState();
                component.set('v.loading',false)
                if(state === 'SUCCESS'){
                    console.log('doInit',response.getReturnValue())
                    const data = response.getReturnValue()
                    if(data && Boolean(data.responseData)){
                        const wallBoard = data.responseData
                        const {totalCallDtv,totalCall}= wallBoard
                        const totalAdditional = Number(totalCall) - Number(totalCallDtv)
                        wallBoard.totalAdditional= totalAdditional
                        component.set('v.wallBoard',wallBoard)
                    }
                }
            })
            $A.enqueueAction(action)
        }
    } 
})