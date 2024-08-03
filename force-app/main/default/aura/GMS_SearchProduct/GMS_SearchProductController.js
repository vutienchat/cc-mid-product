({
    doInit: function(component, event, helper) {
        var action = component.get("c.getDomainOrg");      
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){                
                var result = response.getReturnValue();         
                component.set("v.Spinner", false); 
                component.set("v.domainUrl", result); 
            } else if(state === "INCOMPLETE"){   
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
    
	clickSearch : function(component, event, helper) {
        var keyWord = component.get("v.nhomgiagoi");
		
        if(keyWord != null && keyWord != undefined && keyWord != ''){
            component.set("v.Spinner", true); 
            var action = component.get("c.searchProducts");        
            action.setParams({ 
                'keywork' : keyWord 
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){                
                    var result = response.getReturnValue();  
                    if(result.length > 0) {
                        component.set('v.productList', result); 
                        component.set("v.Spinner", false); 
                        component.set("v.isProduct", true); 
                        component.set("v.isShowMessage", false); 
                    } else {
                        component.set("v.Spinner", false);
                        component.set("v.isShowMessage", true); 
                        component.set("v.isProduct", false); 
                    }
                } else if(state === "INCOMPLETE"){   
                    alert("INCOMPLETE");
                    component.set("v.Spinner", false);
                }else if(state === "ERROR"){    
                    component.set("v.Spinner", false);
                    alert("ERROR");
                }
            });        
            $A.enqueueAction(action);
        } else {
            alert('Vui lòng nhập nhóm giá gói...');
            component.set('v.productList', null);
        }
    }, 
   
    
    handleChange : function(component, event, helper) {
        component.set("v.recordTypeId", event.getParam("value"));
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    success : function(component, event, helper) {
        var rid = event.getParam("id");
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Created Success",
            "message": "Record ID: " + rid
        });
        component.set("v.isOpen", false);
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": rid,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
    
    errors : function(component, event, helper) {
        var error = event.getParams();
        console.log(event.toString());
        var errorMessage = event.getParam("message");
        var errorDetail = event.getParam("detail");
        component.find('notifLib').showToast({
            "variant": "error",
            "title": errorMessage,
            "message": errorDetail
        });
    },
})