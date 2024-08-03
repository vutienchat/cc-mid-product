/**
* @description       : The Class for Handle Point Agent
* @author            : DTDuong - GMS
* @create time       : 2024.04.20
* @last modified on  : 2024.06.02
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/


public without Sharing class HandleScoringAgent {
    @AuraEnabled
    public static Map<String,Object> getListTemplate() {
        Map<String,Object> mapresult = new Map<String,Object>();
        try{
            List<Survey_Template__c> survey_template = [Select id, Name__c, Name, RecordType.DeveloperName  from Survey_Template__c where RecordType.DeveloperName = 'Agent_Scoring'];
            if(survey_template.isEmpty() == false && survey_template.size() < 100 ){
                List<Object> listResult = new List<Object>();
                for(Survey_Template__c item : survey_template){
                    listResult.add(item);
                }
                mapresult.put('listTemplate',listResult);
            }   
        }catch(Exception e){
            system.debug('[GMS_SendSingleSMS_Ctrl] -> getListTemplate() -> exception: '+e.getMessage()+' Inline : '+e.getLineNumber());
            mapresult.put('error',e.getMessage());
        }
        return mapresult;
    }
    
    @AuraEnabled
    public static Map<String,Object> getListQuestion(String templateId) {
        Map<String,Object> mapresult = new Map<String,Object>();
        Map<String,Object> mapGroup = new Map<String,Object>();
        try{
            List<meta_template_question_survey__c> allQuestionRecords = [SELECT Survey_Question__c FROM meta_template_question_survey__c WHERE Survey_Template__c = :templateId];
            
            Set<Id> questionIds = new Set<Id>();
            for (meta_template_question_survey__c record : allQuestionRecords) {
                questionIds.add(record.Survey_Question__c);
            }
            
            List<Survey_Question__c> surveyQuestions = [SELECT Id, Name, Group_question__c FROM Survey_Question__c WHERE Id IN :questionIds];                                  
            if(surveyQuestions.isEmpty() == false && surveyQuestions.size() < 100 ){
                List<Object> listResult = new List<Object>();
                Set<String> listGroup = new Set<String>();
                for(Survey_Question__c item : surveyQuestions){
                    listResult.add(item);
                    listGroup.add(item.Group_question__c);
                }
                mapGroup = getGroupQuestion(listGroup);
                mapresult.put('listQuestion',listResult);
                mapresult.put('listGroup', mapGroup.get('listGroup'));
                
            }
        } catch(Exception e){
            system.debug('[GMS_SendSingleSMS_Ctrl] -> getListTemplate() -> exception: '+e.getMessage()+' Inline : '+e.getLineNumber());
            mapresult.put('error',e.getMessage());
        }
        return mapresult;
    }
    
    @AuraEnabled
    public static Map<String, Object> getCurrentSurvey(String recordId, String type) {
    	Map<String, Object> mapResult = new Map<String, Object>();
        system.debug(recordId);
        try {
            List<Survey_result__c> surveyResults = [SELECT Id, Survey_Template__c,Comment__c,comment2__c,Response_Scoring_Agent__c FROM Survey_result__c WHERE Target_Id__c = :recordId LIMIT 1];
            if (!surveyResults.isEmpty()) {
                mapResult.put('surveyCurrent',surveyResults[0]);
                List<Survey_Result_Item__c> listResultSurvey = [SELECT Id, Survey_Question__r.Name, Result__c, Survey_Question__r.Group_question__c FROM Survey_Result_Item__c WHERE Survey_Result__c = :surveyResults[0].Id AND time_answer__c = :type];
                system.debug(listResultSurvey.toString());
                if(listResultSurvey.size() > 0){
                    Set<String> questionLabelGroup = new Set<String>();
                    Map<String,Object> mapGroup = new Map<String,Object>();
                    for(Survey_Result_Item__c item : listResultSurvey) {
                        questionLabelGroup.add(item.Survey_Question__r.Group_question__c.toString());
                    }
                    mapGroup = getGroupQuestion(questionLabelGroup);
                    mapResult.put('listQuestion', listResultSurvey);
                    mapResult.put('listGroup', mapGroup.get('listGroup'));
                } else {
                    Map<String,Object> listQuestion = getListQuestion(surveyResults[0].Survey_Template__c);mapResult.put('listQuestion', listQuestion.get('listQuestion'));mapResult.put('listGroup', listQuestion.get('listGroup')); 
                }
            }
            
        } catch (Exception e) {
            System.debug('[GMS_SendSingleSMS_Ctrl] -> getCurrentSurvey() -> exception: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            mapResult.put('error', e.getMessage());
        }
        return mapResult;
    }
    
    public static Map<String, Object> getGroupQuestion(Set<String> groupQuestion) {
        Map<String, Object> mapResult = new Map<String, Object>();
        Map<String, GroupWapper> mapKeyWithObject = new Map<String, GroupWapper>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Survey_question__c').getDescribe().fields.getMap().get('Group_question__c').getDescribe();
          
        // Loop through the picklist values and add the active ones to the map
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            if (entry.isActive()) {
                mapKeyWithObject.put(entry.getValue(), new GroupWapper(entry.getLabel(), entry.getValue()));
            }
        }
        
        // Filter the map based on the input list groupQuestion and create a list of relevant picklist entries
        List<GroupWapper> filteredPicklistEntries = new List<GroupWapper>();
        for (String item : groupQuestion) {
            if (mapKeyWithObject.containsKey(item)) {
                filteredPicklistEntries.add(mapKeyWithObject.get(item));
            }
        }
       
        // Add the filtered list to the result map
        mapResult.put('listGroup', filteredPicklistEntries);
        return mapResult;
    }

    
    @AuraEnabled 
    public static Map<String, String> postResultQuestion(String listResult, String recordId, String templateId, String type, String comment) {
        Map<String, String> responseMap = new Map<String, String>();
        List<Survey_Result_Item__c> upDateResultItem = new List<Survey_Result_Item__c>();
        List<Survey_Result_Item__c> insertResultItem = new List<Survey_Result_Item__c>();
        Integer total_point = 0;
        List<SurveyResultWapper> resultWapper = new List<SurveyResultWapper>();
        
        if (listResult.length() > 0) {
            resultWapper = (List<SurveyResultWapper>) System.JSON.deserialize(listResult, List<SurveyResultWapper>.class);
        }

        Survey_result__c surveyExist;
        system.debug('aa' + listResult);
        
        // Query the existing survey result
        List<Survey_result__c> surveyResults = [SELECT Id, CreatedDate FROM Survey_result__c WHERE Target_Id__c = :recordId AND Survey_Template__c = :templateId LIMIT 1];
        
        try {
            if (surveyResults.size() > 0) {
                surveyExist = surveyResults[0];
                system.debug('33' + surveyExist.toString());
                Datetime createTimeSurvey = surveyExist.CreatedDate;
                Datetime currentTime = Datetime.now();
                Boolean checkTime = CheckTime24h(createTimeSurvey);                
                if (checkTime && type == '1') { // kiểm tra thời gian chấm điểm của GSV 1
                    responseMap.put('status', 'error');responseMap.put('mess', 'Bạn đã hết thời gian để chấm điểm bản ghi này');
                    return responseMap; 
                }
                List<Survey_Result_Item__c> oldResults = [SELECT Id, Survey_Question__c FROM Survey_Result_Item__c WHERE Survey_Result__c = :surveyExist.Id AND time_answer__c = :type];
                Map<String, Id> mapIdQuestion = new Map<String, Id>();
                
                for (Survey_Result_Item__c item : oldResults) {
                    system.debug('keymap' + item.Survey_Question__c);
                    system.debug('id' + item.Id);
                    mapIdQuestion.put(item.Survey_Question__c, item.Id);
                }
                
                system.debug('mapidquestion: ' + mapIdQuestion.size());
                
                for (SurveyResultWapper item : resultWapper) {
                    system.debug('key' + item.value);
                    if (mapIdQuestion.containsKey(item.value)) {
                        Survey_Result_Item__c updateResult = new Survey_Result_Item__c();
                        updateResult.Survey_Question__c = item.value;
                        updateResult.Result__c = item.point.toString();
                        updateResult.Name = item.label;
                        updateResult.Id = mapIdQuestion.get(item.value);
                        upDateResultItem.add(updateResult);
                    } else {
                        Survey_Result_Item__c newResult = new Survey_Result_Item__c();
                        newResult.Survey_Question__c = item.value;
                        newResult.Result__c = item.point.toString();
                        newResult.Name = item.label;
                        newResult.Survey_Result__c = surveyExist.id;
                        newResult.time_answer__c = type;
                        system.debug(newResult);
                        insertResultItem.add(newResult);
                    }
                    total_point += item.point;
                }
                
                system.debug(total_point.toString());
                
                if (type == '1') {
                    surveyExist.Total_1__c = total_point.toString();
                    surveyExist.Comment__c = comment;
                    surveyExist.Status__c = 'Scored'; // Change status to first scoring
                }
                if (type == '2') {
                    surveyExist.Total_2__c = total_point.toString();
                    surveyExist.comment2__c = comment;
                    surveyExist.Status__c = 'Done'; // Mark as completed
                }
                
                update surveyExist;
                if (upDateResultItem.size() > 0) update upDateResultItem;
                if (insertResultItem.size() > 0) insert insertResultItem;
            } else {
                // Create a new survey result if it doesn't exist
                Task currentTask = [SELECT Id, Agent__c, Survey_Result__c FROM Task WHERE Id = :recordId LIMIT 1];
                if (currentTask != null) {
                    Survey_result__c newSurvey = new Survey_result__c();
                    newSurvey.Survey_Template__c = templateId; 
                    newSurvey.Target_Id__c = recordId;
                    newSurvey.Scoring_Agent__c = currentTask.Agent__c;
                    insert newSurvey;
                    currentTask.Survey_Result__c = newSurvey.Id;
                    update currentTask;
                    
                    for (SurveyResultWapper item : resultWapper) {
                        Survey_Result_Item__c newResult = new Survey_Result_Item__c();
                        newResult.Survey_Question__c = item.value;
                        newResult.Result__c = item.point.toString();
                        newResult.Name = item.label;
                        newResult.Survey_Result__c = newSurvey.Id;
                        newResult.time_answer__c = '1';
                        upDateResultItem.add(newResult);
                        total_point += item.point;
                        
                        Survey_Result_Item__c newResultSecond = new Survey_Result_Item__c();
                        newResultSecond.Survey_Question__c = item.value;
                        newResultSecond.Result__c = '0';
                        newResultSecond.Name = item.label;
                        newResultSecond.Survey_Result__c = newSurvey.Id;
                        newResultSecond.time_answer__c = '2';
                        upDateResultItem.add(newResultSecond);
                    }
                    
                    insert upDateResultItem;
                    if (type == '1') newSurvey.Total_1__c = total_point.toString();
                    if (type == '2') newSurvey.Total_2__c = total_point.toString();
                    update newSurvey;
                }
            }
            responseMap.put('status', 'success');
            responseMap.put('mess', 'Bạn đã chấm điểm thành công');
        } catch (Exception e) {
            System.debug('[HandleScoringAgent] -> postResultQuestion() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
            responseMap.put('status', 'error');
            responseMap.put('mess', 'Có lỗi xảy ra');
        }
        return responseMap;
    }
    
    @AuraEnabled
    public static Map<String, String> postResponse(String recordId, String templateId, String response) {
        Map<String, String> responseMap = new Map<String, String>();
        Survey_result__c surveyExist;
        List<Survey_result__c> surveyResults = [SELECT Id, CreatedDate FROM Survey_result__c WHERE Target_Id__c = :recordId AND Survey_Template__c = :templateId LIMIT 1];
        try {
            if (surveyResults.size() > 0) {
                surveyExist = surveyResults[0];
                surveyExist.Response_Scoring_Agent__c = response;
                update surveyExist;
                responseMap.put('status', 'success');
            	responseMap.put('mess', 'Bạn đã gửi phản hồi thành công');
            }
        } catch (Exception e) {
            System.debug('[HandleScoringAgent] -> postResponse() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
            responseMap.put('status', 'error');
            responseMap.put('mess', 'Có lỗi xảy ra');
        }
        return responseMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static boolean getUserRole() {
        try {
            // Query the current user's profile name
            User currentUser = [SELECT Id, Name, Email, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            // Get the role from the user's profile name
            String role = currentUser.Profile.Name;
            // Debug the current user's details
            System.debug('Current User: ' + currentUser.toString());
            // Check the role and return the appropriate boolean value
            if (role.equals('System Administrator') || role.equals('Service Supervisor') || role.equals('Service Supervisor MBF')) {
                System.debug('User Role: ' + role);
                return false;
            }
            // Return true if the role is not 'System Administrator' or 'Service Supervisor'
            return true;
        } catch (Exception e) {
            System.debug('[HandleScoringAgent] -> getUserRole() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
            // Return false in case of an exception to ensure safe failure
            return false;
        }
    }

    
    @AuraEnabled(cacheable=true)
    public static boolean getUserService(String recordId) {
        try {
            // Query the current user's profile name
            User currentUser = [SELECT Id, Name, Email, Profile.Name, Id_Agent_Using__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            String role = currentUser.Profile.Name;
            if (role.equals('System Administrator')) {
                System.debug(role);
                return false;
            }
            // If the user is not a 'Service Agent', return true
            if (!role.equals('Service Agent')) { return true;}
            // Query survey results related to the recordId
            List<Survey_result__c> surveyResults = [SELECT Id, Survey_Template__c, Comment__c, comment2__c, Scoring_Agent__c FROM Survey_result__c WHERE Target_Id__c = :recordId LIMIT 1];
    
            // Check if there are survey results and if the current user is the scoring agent
            if (!surveyResults.isEmpty()) {
                if (currentUser.Id_Agent_Using__c == surveyResults[0].Scoring_Agent__c) {return false; }}return true;
        } catch (Exception e) {
            System.debug('[HandleScoringAgent] -> getUserService() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
            return false;
        }
    }

    
    public class SurveyResultWapper { 
        public String label { get; set; }
        public Integer point { get; set; }
        public String value { get; set; }
        public String group_type { get; set; }
    }
    
    public class GroupWapper {
        @AuraEnabled
        public String label { get; set;}
        @AuraEnabled
        public String value { get; set;}
        
        public GroupWapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    public static boolean CheckTime24h(Datetime createTimeSurvey){
        Datetime currentTime = Datetime.now();
        Long millisecondsIn24Hours = 72 * 60 * 60 * 1000;    
        Long differenceInMilliseconds = currentTime.getTime() - createTimeSurvey.getTime();
        if (differenceInMilliseconds > millisecondsIn24Hours) {
            return true; // Exit the method if the survey is older than 24 hours
        }
        return false;
    } 
}