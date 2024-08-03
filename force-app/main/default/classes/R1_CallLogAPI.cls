/**
* @description       : The Class for Call Log APi
* @author            : ndmanh - GMS
* @last modified on  : 2024.06.03
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_CallLogAPI {
	@AuraEnabled        
    public static getCallLogWrapper getCallLogAPI(String taskId){
        System.debug(taskId);
        Task oriTask = [SELECT id, Call_ID__c
                        FROM Task 
                        WHERE id= :taskId];
        
        getCallLogWrapper resultAPI = new getCallLogWrapper();
        // call API getCallLogAPI
        String ResponseBody ='';
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c + 'logaCall?pbxCallId=' + oriTask.Call_ID__c;
        
        String username = Soft_Phone__c.getInstance('userAuthSpx').Value__c;
        
        String password = Soft_Phone__c.getInstance('passwordAuthSpx').Value__c;
        
        system.debug('endpoint :' + endpoint);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
         
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        ResponseBody = response.getBody();
        system.debug('ResponseBody API getCallLogAPI ' + ResponseBody);
        
        if(ResponseBody.length() > 0){
            resultAPI = (getCallLogWrapper) System.JSON.deserialize(ResponseBody, getCallLogWrapper.class);
        }
        
        if(resultAPI.responseCode == '200'){
            Task updateTask = new Task();
            updateTask.Id = taskId;
            updateTask.Call_ID__c 				= resultAPI.responseData.callID;
            updateTask.Start_Time__c 			= Datetime.valueOf(resultAPI.responseData.startDate.replace('T', ' '));
            updateTask.End_Time__c 				= Datetime.valueOf(resultAPI.responseData.endDate.replace('T', ' '));
            updateTask.CC_Agent_Talk_Time__c 	= resultAPI.responseData.agentTalkTimeSeconds;
            updateTask.CC_Link_Record__c 		= resultAPI.responseData.linkRecord;
            if(resultAPI.responseData.linkRecord != null) updateTask.Status = 'Completed';
            updateTask.IsCalled__c 				= True;
            updateTask.CC_Call_Type__c 			= String.valueof(resultAPI.responseData.callType);
            updateTask.Call_Line__c  			= resultAPI.responseData.line;
            updateTask.QueueNumber_Dialed__c	= resultAPI.responseData.numberDial;
            updateTask.Call_Duration__c			= Decimal.valueOf(resultAPI.responseData.duration);
            if(resultAPI.responseData.callType == 1){
                updateTask.CC_Inbound_Phase__c 	= String.valueof(resultAPI.responseData.callPhase);
                updateTask.CC_Inbound_State__c 	= String.valueof(resultAPI.responseData.state);
                updateTask.Call_ID__c 			= resultAPI.responseData.callID;
            }else if(resultAPI.responseData.callType == 2){
                updateTask.CC_Inbound_Phase__c 	= String.valueof(resultAPI.responseData.callPhase);
                updateTask.CC_Outbound_State__c = String.valueof(resultAPI.responseData.state);
                updateTask.Caller_ID__c 		= resultAPI.responseData.customerNumber;
            }
            
            Master_Data__c iAgent = [SELECT id FROM Master_Data__c WHERE Agent_Id__c =: resultAPI.responseData.agentId];
            updateTask.Agent__c 				= iAgent.Id;
            
            update updateTask;
        }
        return resultAPI;
    } 
    
    public class getCallLogWrapper{
       @AuraEnabled public String responseCode;	//200
       @AuraEnabled public String responseMessage;	//Thành công
       @AuraEnabled public responseData responseData;
    }
    
    public class responseData {
        @AuraEnabled public String callID;
        @AuraEnabled public String agentId;
        @AuraEnabled public String transferedAgentId;
        @AuraEnabled public String line;
        @AuraEnabled public String numberDial;
        @AuraEnabled public String startDate;
        @AuraEnabled public String endDate;
        @AuraEnabled public String duration;
        @AuraEnabled public String extension;
        @AuraEnabled public String customerNumber;
        @AuraEnabled public String dialedNumber;
        @AuraEnabled public Decimal state;
        @AuraEnabled public Decimal callPhase;
        @AuraEnabled public Decimal agentTalkTimeSeconds;
        @AuraEnabled public String linkRecord;
        @AuraEnabled public Boolean isCalled;
        @AuraEnabled public Decimal callType;
    }
}