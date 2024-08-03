/**
* @description       : The Controller for Handle Point Agent
* @author            : DTDuong - GMS
* @create time       : 2024.04.20
* @last modified on  : 2024.06.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

({
    doInit : function(component, event, helper) {
        helper.getPermission(component, event, helper);
        helper.getPermissionResponse(component, event, helper);
        helper.getTemp(component, event, helper);  
        helper.getCurrentSurvey(component, event, helper);
    },

    // Select template to score
    handleChangeTemplate : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedTemplate", selectedOptionValue);    
       
        if (selectedOptionValue) {
            var action = component.get("c.getListQuestion");
            action.setParams({
                'templateId': selectedOptionValue
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    if (storeResponse.listQuestion) {
                        var listQuestion = storeResponse.listQuestion.map(function(item) {
                            return {
                                label: item.Name,
                                value: item.Id,
                                point: '',
                                group_type: item.Group_Question__c,
                            };
                        });
                        component.set("v.listQuestion", listQuestion);
                    }
                }  
            });
            $A.enqueueAction(action); 
        }
        component.set("v.Spinner", false); 
    },
    
    handleChange: function(component, event, helper) {
        let questionId = event.currentTarget.id
        let groupKey = event.getSource().get("v.name");
        let point = Number(event.getSource().get('v.value'));
        let isChecked = event.getSource().get("v.checked");
        let listGroup = component.get('v.listGroup');
        let listQuestion = component.get('v.listQuestion');
        let foundGroup = listGroup.find(group => group.key === groupKey);
       
        let foundQuestion = listQuestion.find(question => question.value == questionId);
        if(isChecked && foundQuestion){
            foundQuestion.point = point;
            foundGroup.pointTotal -= point;
        } else {
            foundQuestion.point = 0;
            foundGroup.pointTotal += point;
        }
        console.log(JSON.stringify(foundQuestion));
        component.set("v.listGroup", listGroup);
        component.set("v.listQuestion", listQuestion);
    },
    
    sendResultPoint: function (component, event, helper) {
        var listQuestionResult = component.get("v.listQuestion");
        var recordId = component.get("v.recordId");
        var templateId = component.get("v.selectedTemplate");
        var comment = component.get("v.comment");
        var action = component.get("c.postResultQuestion");
        
        action.setParams({
            'listResult': JSON.stringify(listQuestionResult),
            'recordId': recordId,
            'templateId': templateId,
            'type': '2',
            'comment': comment,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // component.set("v.lockTemplate", true);
                component.find('notifLib').showToast({
                    "title": "Thông báo",
                    "message": storeResponse.mess,
                    "variant": storeResponse.status
                });
                setTimeout(function() {
                    $A.get('e.force:refreshView').fire();
                    location.reload();
                }, 2500);
            } else {
                component.find('notifLib').showToast({
                    "title": "Thông báo",
                    "message": storeResponse.mess,
                    "variant": storeResponse.status
                });
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    sendResponse: function (component, event, helper) {
        var response = component.get("v.AgentScoringResponse");
        var recordId = component.get("v.recordId");
        var templateId = component.get("v.selectedTemplate");
        var action = component.get("c.postResponse");

        action.setParams({
            'recordId': recordId,
            'templateId': templateId,
            'response': response
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // component.set("v.lockTemplate", true);
                component.find('notifLib').showToast({
                    "title": "Thông báo",
                    "message": storeResponse.mess,
                    "variant": storeResponse.status
                });
                setTimeout(function() {
                    $A.get('e.force:refreshView').fire();
                    }, 2500);
            } else {
                component.find('notifLib').showToast({
                    "title": "Thông báo",
                    "message": storeResponse.mess,
                    "variant": storeResponse.status
                });
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
})