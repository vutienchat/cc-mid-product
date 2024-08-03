({
   doInit: function(component, event, helper) {
      // Set isModalOpen attribute to true
       var action = component.get("c.getGlobalPicklistValues");        
       action.setCallback(this, function(response){
           var state = response.getState();
           if(state === "SUCCESS"){          
               var result = response.getReturnValue();  
               component.set("v.isModalOpen", true);
               component.set("v.optionPartner", result);
               component.set("v.valuePartner", result[0].defaultValue);
               component.set("v.defaultValuePartner", result[0].defaultValue);
               component.set("v.selectedPartner", result[0].defaultValue);

               var action2 = component.get("c.getAgentByPartner");   
               action2.setParams({ 
                   'partner' : result[0].defaultValue,
               });
               action2.setCallback(this, function(response){
                   var state = response.getState();
                   if(state === "SUCCESS"){          
                       var result = response.getReturnValue();  
                       component.set("v.optionAgent", result);
                       helper.helperMethod(component, event);  
                   } else if(state === "INCOMPLETE"){   
                       alert("INCOMPLETE");
                       component.set("v.Spinner", false);
                   }else if(state === "ERROR"){    
                       component.set("v.Spinner", false); 
                       alert("ERROR");
                   }
               });        
               $A.enqueueAction(action2);

               helper.helperMethod(component, event);  
           } else if(state === "INCOMPLETE"){   
               alert("INCOMPLETE");
               component.set("v.Spinner", false);
           }else if(state === "ERROR"){    
               component.set("v.Spinner", false); 
               alert("ERROR");
           }
       });        
       $A.enqueueAction(action); 
    },
    handleChangePartner : function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        var defaultPartner = component.get("v.defaultValuePartner");
        if(selectedOptionValue != defaultPartner) {
            alert('Đối tác khu vực bạn chọn đang khác với đối tác khu vực hiện tại của bạn, bạn có chắc chắn muốn thay đổi?');
        }
        component.set("v.selectedPartner", selectedOptionValue);
        var action = component.get("c.getAgentByPartner");   
        action.setParams({ 
            'partner' : selectedOptionValue,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();  
                component.set("v.optionAgent", result);
                helper.helperMethod(component, event);  
            } else if(state === "INCOMPLETE"){   
                alert("INCOMPLETE");
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false); 
                alert("ERROR");
            }
        });        
        $A.enqueueAction(action);
        
   },
    handleChangeStartTime : function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedstartTime", selectedOptionValue);
    },
    handleChangeEndTime : function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedendTime", selectedOptionValue);
    },
    handleChangeAgent : function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedAgent", selectedOptionValue);
    },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
   submitDetails: function(component, event, helper) {
      component.set("v.isModalOpen", false);
       var partner = component.get("v.selectedPartner");
       var agent = component.get("v.selectedAgent");
       var startTime = component.get("v.selectedstartTime");
       var endTime = component.get("v.selectedendTime");
       var fromDate = component.get("v.fromDate");
       var toDate = component.get("v.toDate");
       
       var flow = component.find("myFlow");
       var inpurtVariables = [
           {
           name: "Partner",
           type: "String",
           value: partner
           },
           {
           name: "Agent",
           type: "String",
           value: agent
           },
           {
           name: "startTime",
           type: "String",
           value: startTime
           }, 
           {
           name: "endTime",
           type: "String",
           value: endTime
           },
           {
           name: "Start_Date",
           type: "Date",
           value: fromDate
           },
           {
           name: "End_Date",
           type: "Date",
           value: toDate
           }
       ];
       flow.startFlow("Create_workship_screen", inpurtVariables);
   },
})