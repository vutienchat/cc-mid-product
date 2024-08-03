/**
* @description       : The Class for Log
* @author            : DTDuong - GMS
* @last modified on  : 2024.04.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

public class R1_SMSHistory {
	
    public static void createUpdateSendSMSHistory(String content, String phone, String contactId, String targetObjectId, String typeObject){
        sms_history__c smsHistory = new sms_history__c();
        smsHistory.Is_send__c = false;
        smsHistory.Is_run__c = false;
        smsHistory.sms_content__c = content;
        smsHistory.phone_send__c = phone;
        if(contactId != ''){
            smsHistory.Contact__c = contactId;
        }
        if(typeObject == 'Case'){
            smsHistory.Case__c = targetObjectId;
        }
        if(typeObject == 'Order'){
            smsHistory.Order__c = targetObjectId;
        }
        try {
            Database.insert(smsHistory, false);
        } catch (Exception e) {
            System.debug('[R1_SMSHistory] -> createUpdateSendSMSHistory() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }  
    }
}