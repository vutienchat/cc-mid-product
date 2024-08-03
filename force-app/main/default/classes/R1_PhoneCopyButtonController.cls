/**
* @description       : The Class for Button Create Call Out Task
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.02
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_PhoneCopyButtonController {
    @AuraEnabled 
    public static String getPhone(String recordId){
        String result;
        String objectName;
        String recordIdPrefix = recordId != null ? recordId.substring(0, 3) : null;
        
        switch on recordIdPrefix {
            when '003' {
                objectName = 'Contact';
            }
            when '500' {
                objectName = 'Case';
            }
            when '00T' {
                objectName = 'Task';
            }
            when else {
                objectName = null;
            }
        }
        
        if(objectName == 'Contact'){
            Contact iCont = [SELECT id, Phone FROM Contact WHERE Id =: recordId];
            result = iCont.Phone;
        }else if(objectName == 'Case'){
            Case iCase = [SELECT id, ContactPhone FROM Case WHERE Id =: recordId];
            result = iCase.ContactPhone;
        }else if(objectName == 'Task'){
            Task iTask = [SELECT id, Phone__c FROM Task WHERE Id =: recordId];
            result = iTask.Phone__c;
        }
        return result;
    }
}