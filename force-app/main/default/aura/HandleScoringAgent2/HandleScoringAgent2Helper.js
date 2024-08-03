/**
* @description       : The Helper for Handle Point Agent
* @author            : DTDuong - GMS
* @create time       : 2024.04.20
* @last modified on  : 2024.06.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

({
    getPermission: function(component, event, helper){
        var action = component.get("c.getUserRole");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.checkPermission", storeResponse);
            }
        })
        $A.enqueueAction(action);
    },
    getPermissionResponse: function(component, event, helper){
        var action = component.get("c.getUserService");
        var recordId = component.get("v.recordId");
        action.setParams({
                'recordId': recordId,
            });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                component.set("v.checkPermissionResponse", storeResponse);
            }
        })
        $A.enqueueAction(action);
    },
    getCurrentSurvey: function (component, event, helper){
        var recordId = component.get("v.recordId");
        var action = component.get("c.getCurrentSurvey");
        action.setParams({
                'recordId': recordId,
            	'type': '2'
            });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state === "SUCCESS") {
            var storeResponse = response.getReturnValue();
            if (storeResponse.surveyCurrent != null && storeResponse.listQuestion != null) {
                var templateId = storeResponse.surveyCurrent.Survey_Template__c;
                var comment = storeResponse.surveyCurrent.Comment__c;
                var response = storeResponse.surveyCurrent.Response_Scoring_Agent__c;
                var listQuestion = [];
                var listGroup = [];
                var firstListquestion = [];
                storeResponse.listGroup.forEach(function(item,idx){
                    var groupQuestions = [];
                    var point = 0;
                    var totalPointByGroup = 0;// Array to store questions for this group
                    storeResponse.defaultListQuestion.forEach(function(question) {
                        if (question.Group_question__c === item.value) {
                            groupQuestions.push({
                                label: question.Name,
                                value: question.Id,
                                point: question.point__c ? question.point__c.toString() : '',
                                group_type: question.Group_question__c,
                                checked: false
                            });
                            totalPointByGroup += 10;
                        }
                    })
                    storeResponse.listQuestion.forEach(function(question) {
                        if (question.Survey_Question__r && question.Survey_Question__c) {
                            if (question.Survey_Question__r.Group_question__c === item.value) { 
                                let matchingQuestion = groupQuestions.find(item => item.value === question.Survey_Question__c);
                                if(matchingQuestion && matchingQuestion.point == Number(question.Result__c)){
                                    matchingQuestion.checked = true;
                                    point += Number(question.Result__c);
                                }
                                firstListquestion.push({
                                    label: question.Survey_Question__r.Name,
                                    value: question.Survey_Question__c,
                                    point: question.Result__c,
                                    group_type: question.Survey_Question__r.Group_question__c,                                
                                });
                            }
                        } else {
                            if (question.Group_question__c === item.value) {
                                firstListquestion.push({
                                    label: question.Name,
                                    value: question.Id,
                                    point: 0,
                                    group_type: question.Group_question__c,
                                });
                            }
                        }
                    });
                    listGroup.push({
                        label: item.label,
                        key: item.value,
                        pointTotal: totalPointByGroup - point,
                        listQuestions: groupQuestions // Assign the groupQuestions array to listQuestions attribute
                    });
                });
                console.log('333'+ JSON.stringify(listGroup));
                component.set("v.listQuestion", firstListquestion);
                component.set("v.listGroup", listGroup);
                component.set("v.selectedTemplate", templateId);
                component.set("v.comment", comment);
                component.set("v.AgentScoringResponse", response);
                // component.set("v.lockTemplate", true);
            	}
        	}
        });
        $A.enqueueAction(action); 
    },
	getTemp : function(component, event, helper) {
        var action = component.get("c.getListTemplate");
        var items = [];
        for (var i = 0; i < 500; i++) {
            var item = {
                "label": i + " Option",
                "value": i.toString()
            };
            items.push(item);
        }
        component.set("v.listTemplate", items);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse.listTemplate != null){
                    var listTemplate = [];
                    console.log(item);
                    console.log(storeResponse.listTemplate);
                    storeResponse.listTemplate.forEach(function(item,idx) {
                        listTemplate.push({
                            label:item.Name,
                            value:item.Id
                        })
                    });
                    component.set("v.listTemplate", listTemplate);
                }
            }
        });
        $A.enqueueAction(action); 
    }
    
})