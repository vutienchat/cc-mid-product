/**
* @description       : The Class for Public Survey for Customer
* @author            : ndmanh - GMS
* @last modified on  : 2024.05.31
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public without sharing class R1_Survey {
	public class wrapperQuestion {
        @AuraEnabled public List<wrapperAnswer> Answer;
        @AuraEnabled public String Question;
        @AuraEnabled public boolean multipleAnswer;
        @AuraEnabled public String questionId;
        @AuraEnabled public String templateId;
        @AuraEnabled public String objectId;
        @AuraEnabled public String templateName;
        @AuraEnabled public String result;
        @AuraEnabled public String reason;
    }
    
    public class wrapperAnswer {
        @AuraEnabled public String value;
        @AuraEnabled public String label;
    }
    @AuraEnabled
    public static List<wrapperQuestion> getQuestion(String recordId){ // String templateName
        String objectName;
        
        List<wrapperQuestion> result = new List<wrapperQuestion>();
        
        String recordIdPrefix = recordId != null ? recordId.substring(0, 3) : null;
        
        switch on recordIdPrefix {
            when '701' {
                objectName = 'Campaign';
            }
            when '500' {
                objectName = 'Case';
            }
            when else {
                objectName = 'Template';
            }
        }
        
        if(objectName == 'Campaign'){
            List<Survey_Question__c> lstQuestion = [SELECT id, Multiple_answers__c, Name, Answers__c, Campaign__r.Name
                                                    FROM Survey_Question__c 
                                                    WHERE Campaign__c =: recordId];
            
            if(lstQuestion.size() > 0){
                for(Survey_Question__c iQuestion :lstQuestion){
                    wrapperQuestion iResult = new wrapperQuestion();
                    // Câu hỏi và các thông tin liên quan
                    iResult.multipleAnswer = iQuestion.Multiple_answers__c;
                    iResult.Question = iQuestion.Name;
                    iResult.questionId = iQuestion.id;
                    iResult.objectId = recordId;
                    iResult.templateName = iQuestion.Campaign__r.Name;
                    // câu trả lời có dạng a;b;c => Split để tạo list answer
                    if(iQuestion.Answers__c.contains(';')){
                        List<wrapperAnswer> resultAnswer = new List<wrapperAnswer>();
                        List<String> lstAnswer = iQuestion.Answers__c.split(';');
                        if(lstAnswer.size() > 0){
                            for(String iAnswer :lstAnswer){
                                wrapperAnswer iAnswerResult = new wrapperAnswer();
                                iAnswerResult.value = iAnswer;
                                iAnswerResult.label = iAnswer;
                                
                                resultAnswer.add(iAnswerResult);
                            }
                        }
                        
                        if(resultAnswer.size() > 0) iResult.Answer = resultAnswer;
                        
                        result.add(iResult);
                    }
                }
            }
        }else if(objectName == 'Template'){
            // đoạn code phía dưới cho tempalte meta
            List<meta_template_question_survey__c> lstMeta = [SELECT Survey_Question__c, Survey_Question__r.Name, 
                                                              Survey_Question__r.Answers__c, Survey_Question__r.Group_question__c, Survey_Question__r.Multiple_answers__c,
                                                              Survey_Template__c, Survey_Template__r.Name
                                                              FROM meta_template_question_survey__c
                                                              WHERE Survey_Template__r.Id =: recordId];
            
            if(lstMeta.size() > 0){
                for(meta_template_question_survey__c iMeta :lstMeta){
                    wrapperQuestion iResult = new wrapperQuestion();
                    // Câu hỏi và các thông tin liên quan
                    iResult.multipleAnswer = iMeta.Survey_Question__r.Multiple_answers__c;
                    iResult.Question = iMeta.Survey_Question__r.Name;
                    iResult.questionId = iMeta.Survey_Question__c;
                    iResult.templateId = iMeta.Survey_Template__c;
                    iResult.objectId = recordId;
                    iResult.templateName = iMeta.Survey_Template__r.Name;
                    // câu trả lời có dạng a;b;c => Split để tạo list answer
                    if(iMeta.Survey_Question__r.Answers__c.contains(';')){
                        List<wrapperAnswer> resultAnswer = new List<wrapperAnswer>();
                        List<String> lstAnswer = iMeta.Survey_Question__r.Answers__c.split(';');
                        if(lstAnswer.size() > 0){
                            for(String iAnswer :lstAnswer){
                                wrapperAnswer iAnswerResult = new wrapperAnswer();
                                iAnswerResult.value = iAnswer;
                                iAnswerResult.label = iAnswer;
                                
                                resultAnswer.add(iAnswerResult);
                            }
                        }
                        
                        if(resultAnswer.size() > 0) iResult.Answer = resultAnswer;
                        
                        result.add(iResult);
                    }
                }
            }
        }else if(objectName == 'Case'){
            // đoạn code phía dưới cho Case
            List<meta_template_question_survey__c> lstMeta = [SELECT Survey_Question__c, Survey_Question__r.Name, 
                                                              Survey_Question__r.Answers__c, Survey_Question__r.Group_question__c, Survey_Question__r.Multiple_answers__c,
                                                              Survey_Template__c, Survey_Template__r.Name
                                                              FROM meta_template_question_survey__c
                                                              WHERE Survey_Template__r.Name = 'CSAT - CSKH - CL DV TƯƠNG TÁC'];
            if(lstMeta.size() > 0){
                for(meta_template_question_survey__c iMeta :lstMeta){
                    wrapperQuestion iResult = new wrapperQuestion();
                    // Câu hỏi và các thông tin liên quan
                    iResult.multipleAnswer = iMeta.Survey_Question__r.Multiple_answers__c;
                    iResult.Question = iMeta.Survey_Question__r.Name;
                    iResult.questionId = iMeta.Survey_Question__c;
                    iResult.templateId = iMeta.Survey_Template__c;
                    iResult.objectId = recordId;
                    iResult.templateName = iMeta.Survey_Template__r.Name;
                    // câu trả lời có dạng a;b;c => Split để tạo list answer
                    if(iMeta.Survey_Question__r.Answers__c.contains(';')){
                        List<wrapperAnswer> resultAnswer = new List<wrapperAnswer>();
                        List<String> lstAnswer = iMeta.Survey_Question__r.Answers__c.split(';');
                        if(lstAnswer.size() > 0){
                            for(String iAnswer :lstAnswer){
                                wrapperAnswer iAnswerResult = new wrapperAnswer();
                                iAnswerResult.value = iAnswer;
                                iAnswerResult.label = iAnswer;
                                
                                resultAnswer.add(iAnswerResult);
                            }
                        }
                        
                        if(resultAnswer.size() > 0) iResult.Answer = resultAnswer;
                        
                        result.add(iResult);
                    }
                }
            }
        }
        
        system.debug('result: ' + result);
        return result;
    }
    
    @AuraEnabled
    public static Contact getInforContactDB(String phone){
        Id customerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        
        Contact result = [SELECT id, name
                         FROM Contact 
                         WHERE Phone = :Phone
                         AND recordtypeId = :customerRT_Id
                         AND Status__c = '1'];
        return result;
    }
    
    @AuraEnabled
    public static String saveSurvey(String idata, String Phone){
        String result;
		system.debug('idata :' + idata);
        system.debug('Phone :' + Phone);
        List<wrapperQuestion> lstResult = new List<wrapperQuestion>();
        
        if(idata.length() > 0){
            lstResult = (List<wrapperQuestion>) System.JSON.deserialize(idata, List<wrapperQuestion>.class);
        }
        
        Id customerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        
        Contact iCont = [SELECT id 
                         FROM Contact 
                         WHERE Phone = :Phone
                         AND recordtypeId = :customerRT_Id
                         AND Status__c = '1'];
        
        if(lstResult.size() > 0){
            // tạo survey result lấy id
            Survey_Result__c surveyResult = new Survey_Result__c();
            String inputString = lstResult[0].templateName + '_' + String.valueof(Date.today());
            if (inputString != null && inputString.length() > 80) {
                inputString = inputString.substring(0, 79);
            }
            surveyResult.Name = inputString;
            surveyResult.Survey_Template__c = lstResult[0].templateId;
            String recordIdPrefix = lstResult[0].objectId != null ? lstResult[0].objectId.substring(0, 3) : null;
            
            switch on recordIdPrefix {
                when '701' {
                    //objectName = 'Campaign';
                    surveyResult.Campaign__c = lstResult[0].objectId;
                }
                // cần thay đổi khi đổi môi trường
                when 'a0J' {
                    //objectName = 'Template';
                }
                when '500' {
                    //objectName = 'Case';
                    surveyResult.Case__c = lstResult[0].objectId;
                }
                when else {
                    //objectName = null;
                }
            }
            
            surveyResult.Contact__c = iCont.Id;
            insert surveyResult;
            system.debug('surveyResult Id' + surveyResult);
            
            List<Survey_Result_Item__c> lstSurveyItems = new List<Survey_Result_Item__c>();
            // tạo câu trả lời - survey result items
            for(wrapperQuestion iSurveyResult: lstResult){
                Survey_Result_Item__c surveyItem 	= new Survey_Result_Item__c();
                surveyItem.Survey_Question__c 		= iSurveyResult.questionId;
                surveyItem.Survey_Result__c 		= surveyResult.Id;
                surveyItem.Result__c 				= iSurveyResult.result;
                surveyItem.Reason__c 				= iSurveyResult.reason;
                
                lstSurveyItems.add(surveyItem);
            }
            
            if(lstSurveyItems.size() > 0) insert lstSurveyItems;
            
            result = surveyResult.Id;
        }
        return result;
    }
}