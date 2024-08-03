public class R1_SurveyResultNoteController {
    @AuraEnabled
    public static boolean checkPermission(){
        User currentUser =[SELECT id, Profile.Name FROM User WHERE id = :UserInfo.getUserId()];
        
        return (!currentUser.Profile.Name.contains('Service Supervisor'));
    }
    
	@AuraEnabled
    public static String createTask(String recordId, String reason){
        String result;
        
        Id callRT_Id = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Call').getRecordTypeId();
        
        Task oldTask = [SELECT id, WhoId, WhatId, OwnerId, Agent__c, Phone__c, Caller_ID__c
                        FROM Task 
                        WHERE id = :recordId];
        
        Task newTask = new Task();
        newTask.RecordTypeId = callRT_Id;
        newTask.Subject = oldTask.Phone__c + '_OUTBOUND_YCGSV_' + String.valueof(Datetime.now());
        newTask.WhoId = oldTask.WhoId;
        newTask.WhatId = oldTask.WhatId;
        newTask.OwnerId = oldTask.OwnerId;
        newTask.Agent__c = oldTask.Agent__c;
        newTask.Type = 'Outbound';
        newTask.Priority = 'High';
        newTask.Reason__c = 'GSV yêu cầu gọi lại';
        newTask.Phone__c = oldTask.Phone__c;
        newTask.Caller_ID__c = oldTask.Caller_ID__c;
        newTask.Survey_Information__c = reason;
        
        insert newTask;
        
        return newTask.Id;
    }
}