/**
* @description       : The Class for Log
* @author            : DTDuong - GMS
* @last modified on  : 2024.04.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

global class SendSingleSMS_Ctrl {
    
    //Function get list SMS template
    @AuraEnabled
    Global static map<String,Object> getListTemplate() {
        map<String,Object> mapresult = new map<String,Object>();
        try{
        	List<SMS_Template__c> listSMSTemp = [Select id,Date_From__c, Date_To__c, Name,SMS_Type__c, SMS_Template__c from SMS_Template__c];
            
            
            if(listSMSTemp.isEmpty() == false && listSMSTemp.size() < 100 ){
                List<Object> listResult = new List<Object>();
                for(SMS_Template__c item : listSMSTemp){
                    listResult.add(item);
                    }
                    mapresult.put('listEmailTemplate',listResult);
                }   
            } catch(Exception e){
                system.debug('[GMS_SendSingleSMS_Ctrl] -> getListTemplate() -> exception: '+e.getMessage()+' Inline : '+e.getLineNumber());
                mapresult.put('error',e.getMessage());
            }
        return mapresult;
    }
    
    //Function parse body sms from email template
    @AuraEnabled
    Global static map<String,Object> get_SMS_body(String templateName) {
        map<String,Object> mapresult = new map<String,Object>();
        try{
            if(String.isNotBlank(templateName)){
                SMS_Template__c smsTemplate = [Select id,Date_From__c, Date_To__c, Name,SMS_Type__c, SMS_Template__c from SMS_Template__c where id =:templateName limit 1];
                mapresult.put('body_SMS',smsTemplate.SMS_Template__c);
            }
        }catch(Exception e) {
            system.debug('[GMS_SendSingleSMS_Ctrl] -> get_SMS_body() -> exception: '+e.getMessage()+' Inline : '+e.getLineNumber());
            mapresult.put('error',e.getMessage());
        }
        return mapresult;
    }
    //Function Send SMS
    @AuraEnabled
    global static map<String,Object> sendSms(String recordId, String smscontent, String typeObject) {
        String responseData = '';
        String requestBody = '';
        String phone = '';
        String contactId = '';
        map<String,Object> mapresult = new map<String,Object>();
        try {
            if(typeObject == 'Case') {
                Case caseData = [SELECT Id, Contact__r.Phone, Contact__c FROM Case WHERE Id = :recordId LIMIT 1];
                phone = caseData?.Contact__r.Phone;
                contactId = caseData?.Contact__c;
            } else if(typeObject == 'Contact') {
                Contact contactData = [SELECT Id, Phone FROM Contact WHERE Id = :recordId LIMIT 1];
                phone = contactData?.Phone;
                contactId = contactData?.Id;
            }
    
            if(String.isNotBlank(phone)) {
                // Construct the JSON request body
                Map<String, String> requestBodyMap = new Map<String, String>();
                requestBodyMap.put('phone_number', phone);
                requestBodyMap.put('message', smscontent);
                requestBody = JSON.serialize(requestBodyMap);
                System.debug(requestBody);
    
                // Perform the HTTP callout
                HttpResponse result = GMS_CallApiGateway.callApi('send-sms', 'omni_send_sms_hn', 'POST', requestBody, 'http://42.1.67.22:8001/');
                responseData = result.getBody().toString();
                ResponseWrapper response = (ResponseWrapper) JSON.deserialize(responseData, ResponseWrapper.class);
                mapresult.put('status', response.status);
                mapresult.put('code', 200);
                
                R1_SMSHistory.createUpdateSendSMSHistory(smscontent, phone, contactId, recordId, typeObject);
            } else {
                mapresult.put('status', 'Phone number is not available');
                mapresult.put('code', 500);
            }
    
        } catch (System.CalloutException e) {
            System.debug('[GMS_SendSingleSMS_Ctrl] -> sendSms() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
            mapresult.put('status', e.getMessage());
            mapresult.put('code', 500);
        }
        return mapresult;
    }

    
    public Boolean createUpdateSMSHistory(String recordId, String smscontent, String type_object_send, String type_target_send, String phone, Boolean is_run, Boolean is_send) {
        // Query for existing SMS history record with the given phone number
        List<sms_history__c> currentSmsHistory = [SELECT Id FROM sms_history__c WHERE phone_send__c = :phone];
        sms_history__c smsHistory; 
    
        // If a record exists, use it; otherwise, create a new one
        if (currentSmsHistory.size() > 0) {
            smsHistory = currentSmsHistory[0];
        } else {
            smsHistory = new sms_history__c();
        }
    
        // Update fields
        smsHistory.Is_run__c = is_run;
        smsHistory.Is_send__c = is_send;
        smsHistory.phone_send__c = phone;
        smsHistory.sms_content__c = smscontent;
    
        try {
            // Insert or update the record
            upsert smsHistory;
            return true;
        } catch (Exception e) {
            // Handle the exception (could log the error or rethrow it)
            System.debug('Error in createUpdateSMSHistory: ' + e.getMessage());
            return false;
        }
    }

    public class ResponseWrapper {
    	public String status { get; set; }
    }
}