/**
* @description       : The Class for Button Create Call Out Task
* @author            : ndmanh - GMS
* @last modified on  : 2024.06.05
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_CallOutCase {
    @AuraEnabled
    public static String createTask(String recordId){
        String result;
        String objectName;
        system.debug('recordId :' + recordId);
        String recordIdPrefix = recordId != null ? recordId.substring(0, 3) : null;
        
        switch on recordIdPrefix {
            when '00Q' {
                objectName = 'Lead';
            }
            // cần thay đổi khi đổi môi trường
            when '006' {
                objectName = 'Opp';
            }
            when '500' {
                objectName = 'Case';
            }
            when '801' {
                objectName = 'Order';
            }
            when else {
                objectName = null;
            }
        }
        
        try{
            Task newTask = new Task();
            system.debug('objectName :' + objectName);
            if(objectName == 'Case'){
                User u = [SELECT id, Id_Agent_Using__c FROM user WHERE id =: UserInfo.getUserId()];
                // get case by record id
                Case iCase = [SELECT id, Ownerid, ContactPhone, CaseNumber, ContactId, Accept_Agent__c
                              FROM Case 
                              WHERE id= :recordId];
                
                //get recordtype Id Call
                Id callRT_Id = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Call').getRecordTypeId();
                
                
                //newTask.OwnerId = iCase.OwnerId;
                newTask.Phone__c = iCase.ContactPhone;
                newTask.Caller_ID__c = iCase.ContactPhone;
                newTask.ActivityDate = date.today();
                newTask.WhatId = iCase.Id;
                newTask.RecordTypeId = callRT_Id;
                newTask.Subject = 'Outbound_' + iCase.CaseNumber + String.valueof(Datetime.now());
                newTask.Type = 'Outbound';
                newTask.WhoId = iCase.ContactId;
                newTask.Agent__c = iCase.Accept_Agent__c;
                newTask.Reason__c = 'Call Out';
                newTask.Agent__c = u.Id_Agent_Using__c;
            }else if(objectName == 'Lead'){
                // get case by record id
                Lead iLead = [SELECT id, Ownerid, Name, Phone
                              FROM Lead 
                              WHERE id= :recordId];
                
                //get recordtype Id Call
                Id salesCallRT_Id = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Sales_Call_Out').getRecordTypeId();
                
                
                newTask.OwnerId = iLead.OwnerId;
                newTask.Phone__c = iLead.Phone;
                newTask.Reason__c = 'NVBH thu thập thông tin KHTN';
                newTask.ActivityDate = date.today();
                newTask.Caller_ID__c = iLead.Phone;
                //newTask.WhatId = iLead.Id;
                newTask.RecordTypeId = salesCallRT_Id;
                newTask.Subject = 'Gọi ra_' + iLead.Name + '_' + String.valueof(Datetime.now());
                newTask.Type = 'Outbound';
                newTask.WhoId = iLead.Id;
                newTask.Status = 'Open';
            }
            
            insert newTask;
            
            result = URL.getOrgDomainUrl().toExternalForm() + '/' + newTask.Id;
        }catch (Exception ex) {        
            System.debug('R1_CallOutCase --> createTask:' + ex.getMessage() + '-' + ex.getStackTraceString());	    
            throw new AuraHandledException(ex.getMessage());		
            
            // return null;
        }
        
        return result;
    }
}