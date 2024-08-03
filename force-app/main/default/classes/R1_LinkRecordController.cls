/**
* @description       : The Class for get call Id with Task Id
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.11
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_LinkRecordController {
	@AuraEnabled
    public static Task getCallId(String recordId){
        Task result = new Task();
        try{
            result = [SELECT id, Call_ID__c FROM Task WHERE id=: recordId];
        }catch (Exception ex) {throw new AuraHandledException(ex.getMessage());		

            // return null; 
        }
        return result;
    }
}