({
    doInit : function(component, event, helper) {
        component.set("v.isChooseAgent", true);
         var values = component.get("v.selectedValue");  
            var action = component.get("c.SearchAgent");        
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue(); 
                    if(result.length == 0) {
                        component.set('v.isAgent', false);
                    } else {
                        component.set('v.isAgent', true);
                    }
                    component.set('v.isShowListAgent', true);
                    component.set('v.agentList', result);
                    /*
                    var result = response.getReturnValue(); 
                    if(result.Name === undefined) {
                        component.set("v.isAgent", false);
                    } else {
                        component.set("v.isAgent", true);
                        component.set("v.agent", result); 
                        component.set("v.isChooseChannel", true);
                        component.set("v.isLogin", true);
                        if(result.isClockIn === true) {
                            component.set("v.isClockIn", true);
                        }
                        if(values != undefined) {
                            component.set("v.isChooseChannel", false);
                        }
                        helper.updateCurrentTime(component);
                    } 
                    */
                } else if(state === "INCOMPLETE"){   
                }else if(state === "ERROR"){    
                }
            });        
            $A.enqueueAction(action);
        
        //check online agent
        var action2 = component.get("c.checkOnlineAgent");        
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
                var result = response.getReturnValue(); 
                    if(result.Name === undefined) {
                        component.set("v.isAgent", false);
                    } else {
                        if(result.channel == 'Kênh số') {
                            component.set("v.isSo", false);
                        }
                        component.set("v.isAgent", true);
                        component.set("v.agent", result); 
                        var dateTime = new Date(result.Clock_in);
                        //Date clockinDate = result.Clock_in;
                        
                        var displayDate = dateTime.getDate() + '-' + (dateTime.getMonth()+1) + '-' + dateTime.getFullYear() +  ' ' + (dateTime.getHours()) + ':' + dateTime.getMinutes()  + ':' + dateTime.getSeconds();
                        component.set("v.displayDate", displayDate); 
                        component.set("v.isChooseChannel", true);
                        component.set("v.isLogin", true);
                        if(result.isClockIn === true) {
                            component.set("v.isClockIn", true);
                        }
                        if(values != undefined) {
                            component.set("v.isChooseChannel", false);
                        }
                        helper.updateCurrentTime(component);
                    } 
                
            } else if(state === "INCOMPLETE"){   
            }else if(state === "ERROR"){    
            }
        });        
        $A.enqueueAction(action2);
    }, 
    handleChooseAgent : function(component, event, helper) {
        component.set("v.isChooseChannel", true);
       var value = event.getSource().get('v.value');
        var action = component.get("c.HandleChooseAgent");
        action.setParams({
            'idAgent' : value,
        });
        action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue(); 
                    component.set('v.isAgent', true);
                    component.set('v.isLogin', true);
                    component.set('v.isShowListAgent', false);
                    component.set('v.agent', result);
                    
                } else if(state === "INCOMPLETE"){   
                }else if(state === "ERROR"){    
                }
            });        
            $A.enqueueAction(action);
    }, 
    clockIn : function(component, event, helper) {
        //var value = event.getSource().get('v.value');
        var value = component.get("v.selectedAgent");
        var action = component.get("c.UpdateClockIn");
        var valueCheck = component.get("v.selectedValue");
        var workplaceId = component.get("v.workplaceId");
         
        action.setParams({
            'idAgent' : value,
            'valueCheck' : valueCheck,
            'workplaceId' : workplaceId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state');
            console.log(state);
            if(state === "SUCCESS"){                
                var result = response.getReturnValue();
                if(result.isLogin === true || result.channel === 'Kênh số') {
                    component.set("v.agent", result); 
                    var dateTime = new Date(result.Clock_in);
                    var displayDate = dateTime.getDate() + '-' + (dateTime.getMonth()+1) + '-' + dateTime.getFullYear() +  ' ' + (dateTime.getHours()) + ':' + dateTime.getMinutes() + ':' + dateTime.getSeconds();
                    component.set("v.displayDate", displayDate); 
                    if(result.isClockIn === true) {
                        component.set("v.isClockIn", true);
                        component.set("v.isChooseChannel", false);
                        component.set("v.isLogin", false);
                        $A.get('e.force:refreshView').fire();
                        location.reload();
                    }
                    helper.updateCurrentTime(component);
                } else {
                    component.set("v.isLogin", false); 
                    component.set("v.isShowWarning", true); 
                    component.set("v.isClockIn", false);
                    component.set("v.isThoai", true);
                    window.setTimeout(function(){ 
                        helper.closeWarning(component, event)
                    }, 5000);

                }
            } else if(state === "INCOMPLETE"){   
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false);
            }
        });        
        $A.enqueueAction(action);
    }, 
    clockOut : function(component, event, helper) {
        var value = component.get("v.selectedAgent");
        var valueCheck = component.get("v.selectedValue");
         var workplaceId = component.get("v.workplaceId");
        var agent = component.get("v.agent");
         var action = component.get("c.UpdateClockOut"); 

        action.setParams({
            'idAgent' : agent.Id,
            'valueCheck' : agent.channel,
            'workplaceId' : agent.ExtensionId 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){      
                $A.get('e.force:refreshView').fire();
                var result = response.getReturnValue();
                if(result.isLogin == false) {
                    component.set("v.agent", result); 
                    component.set("v.isClockIn", false);
                    component.set("v.isChooseChannel", true);
                    component.set("v.isLogin", true);
                } else {
                    component.set("v.isClockIn", true);
                    component.set("v.isShowLogOut", true);
                    window.setTimeout(function(){ 
                        helper.closeWarningClockout(component, event)
                    }, 5000);

                    
                }
                //helper.updateCurrentTime(component);
 
            } else if(state === "INCOMPLETE"){   
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
    onChangeValue : function (component, event, helper) {
        var myValue = event.getSource().get("v.value");
        var agentId = component.get("v.selectedAgent");
        var agent = component.get("v.agentList");
        var partner;
        for(var i = 0 ; i < agent.length ; i++) {
            if(agent[i].Id == agentId) {
                partner = agent[i].partner;
            }
        }
        if(myValue != "0") {
            component.set("v.isChooseChannel", false);
            component.set("v.selectedValue", myValue);
            component.set("v.isChooseFull" , true);
            if(myValue == 'kenhthoai') {
                var action = component.get("c.HandleChooseShiftForAgent");
                action.setParams({
                    'partner' : partner, 
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var result = response.getReturnValue(); 
                        component.set("v.isThoai", true);
                        if(result.isFull == 'false') {
                            component.set("v.extensionNumber", result.ExtensionNumber);
                            component.set("v.workplaceId", result.WorkplaceId);
                        } else{
                            component.set("v.isFullSlot", true);
                            window.setTimeout(function(){ 
                                helper.closeWarningFull(component, event)
                            }, 5000);
                        }
                    } 
                       else if(state === "INCOMPLETE"){   
                    }else if(state === "ERROR"){    
                    }  
                });        
                $A.enqueueAction(action);
            } else {
                component.set("v.isThoai", false);
            }
        } else {
            component.set("v.isChooseChannel", true);
            component.set("v.isChooseFull" , false);
        } 
    },
    onChangeAgent : function (component, event, helper) {
        var myValue = event.getSource().get("v.value");
        var agent = component.get("v.agentList");
        
        component.set("v.selectedAgent", myValue);
        if(myValue != "0") {
            component.set("v.isChooseAgent", false);
        } else {
            component.set("v.isChooseAgent", true);
        }
    },
    
})