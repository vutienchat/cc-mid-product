/**
* @description       : The Class for test MBFPhoneController
* @author            : vu.chat - Sphinx
* @last modified on  : 2024.07.05
* @last modified by  : vu.chat
* @history           :    date                    author                      content
**/
public with sharing class MBFPhoneController {
    public class InfoCall {
        @AuraEnabled public Contact contact;
        @AuraEnabled public String caseId;
        @AuraEnabled public String taskId;
    }
    
    public class InfoAgent {
        @AuraEnabled public String agentId;	
        @AuraEnabled public String extensionId;
        @AuraEnabled public String agentCode;
        @AuraEnabled public String name;
        @AuraEnabled public String profileName;
    }

    @AuraEnabled(cacheable=true)
    public static List<InfoAgent> searchAgents(string searchKey){
        try {
            String key = '%' + searchKey + '%';
            String userId = UserInfo.getUserId();
            List<InfoAgent> agents = new List<InfoAgent>();
            List<User> users  = [SELECT Id, name, Id_Agent_Using__c,ExtensionId__c 
                                 FROM user
                                 WHERE Id_Agent_Using__c != null
                                 AND ExtensionId__c != null
                                 AND Id != :userId
                                 AND (Name LIKE :key OR Extensionid__c LIKE :key)
                                ];
            for(User user : users) {
                List<Master_Data__c> masterData = [SELECT id, name,Agent_Id__c,Agent_code__c from Master_Data__c where id = :user.Id_Agent_Using__c 
                                                   AND Agent_Id__c != null];
                if(!masterData.isEmpty()){
                    InfoAgent agent = new InfoAgent();
                    agent.agentId= masterData[0].Agent_Id__c;
                    agent.agentCode= masterData[0].Agent_code__c;
                    agent.extensionId= user.ExtensionId__c;
                    agent.name= user.name;
                    agents.add(agent);
                }
            }
            System.debug('Response: ' + agents);
            return agents;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static InfoAgent getUser(){
        try {
            String userId = UserInfo.getUserId();
            User currentUser = [SELECT id,Extensionid__c, Id_Agent_Using__c,name,Profile.Name FROM User WHERE Id =: userId];
            List<Master_Data__c> userFS = [SELECT id, Agent_Id__c  FROM Master_Data__c WHERE Id =: currentUser.Id_Agent_Using__c AND Agent_Id__c != null];
            if(!userFS.isEmpty()){
                InfoAgent InfoAgent = new InfoAgent();
                InfoAgent.agentId= userFS[0].Agent_Id__c;
                InfoAgent.extensionId= currentUser.Extensionid__c;
                InfoAgent.name= currentUser.name;
                InfoAgent.profileName = currentUser.Profile.Name;
                return InfoAgent;
            }
            System.debug('currentUser: ' + currentUser);
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static InfoCall getInfoCallByPhone(String Phone){
        InfoCall InfoCall = new InfoCall();
        String contactId;
        Id nonCustomerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Non_Customer').getRecordTypeId();
        try {
            List<Contact> contacts = [SELECT Name,Phone,Email,Address__c,AccountId,VIP__c,
                                      Account.Name,Account.Bus_Type__c, Account.birth_Date__c, Account.email__c, Account.vip__c, Account.Phone,Account.Id_No__c
                                      FROM Contact 
                                      WHERE Phone = :Phone LIMIT 1];
            if (contacts.size() > 0) {
                InfoCall.contact = contacts[0];
                contactId = contacts[0].Id;
            } else {
                Contact newCont = new Contact();
                newCont.RecordTypeId = nonCustomerRT_Id;
                newCont.Phone = Phone;
                newCont.LastName = Phone;
                insert newCont;
                
                InfoCall.contact = newCont;
                contactId = newCont.Id;
            }
            return InfoCall;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static InfoCall autoCreateCase(String contactId, String Phone, String callId){
        InfoCall InfoCall = new InfoCall();
        
        // Lấy thông tin Agent Id
        String userId = UserInfo.getUserId();
        User currentUser = [SELECT id, Id_Agent_Using__c FROM User WHERE Id =: userId];
        Master_Data__c agentInfo = [SELECT id, Management_Unit__c  FROM Master_Data__c WHERE Id =: currentUser.Id_Agent_Using__c];
        
        Id nonCustomerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Non_Customer').getRecordTypeId();
        Id customerSupportRT_Id = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        Id callRT_Id = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Call').getRecordTypeId();
        try {       
            if(contactId != null){
                system.debug('Contact Id: ' + contactId);
                // Tạo Case tự động
                Case newCase = new Case();
                newCase.RecordTypeId = customerSupportRT_Id;
                newCase.Contact__c = contactId;
                newCase.ContactId = contactId;
                newCase.Call_ID__c = callId;
                insert newCase;
                // thêm id Case vào result
                InfoCall.caseId = newCase.Id;
                
                system.debug('newCase Id: ' + newCase);
                // Tạo Task log a call
                Task newTask = new Task();
                newTask.RecordTypeId = callRT_Id;
                newTask.Type = 'Inbound';
                newTask.Subject = Phone + '_In_' + Date.today();
                newTask.WhoId = contactId;
                newTask.WhatId = newCase.Id;
                newTask.Agent__c = agentInfo.Id;
                newTask.Phone__c = Phone;
                newTask.Linkage_Id__c = callId;
                newTask.ActivityDate = date.today();
                newTask.Status = 'Completed';
                newTask.Reason__c = 'Call In';
                Insert newTask;
                InfoCall.taskId = newTask.Id;
            }
            return InfoCall;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static void getCallLog(String taskId) {
        R1_CallLogAPI.getCallLogAPI(taskId);
    }
    
    @AuraEnabled(cacheable=false)
    public static ResponseMiddleware getCalls(String agentId,String state,String pageNumber,String pageSize) {
        ResponseMiddleware resultAPI = new ResponseMiddleware();
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'getCalls?agentId='+agentId +'&state='+ state + '&pageNumber=' + pageNumber + '&pageSize=' + pageSize; 
        String authorizationHeader = getAuthorizationHeader();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Accept', '*/*');
        request.setTimeout(10000);
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            // System.debug('Response: ' + responseBody);
            resultAPI = (ResponseMiddleware) System.JSON.deserialize(response.getBody(),ResponseMiddleware.class);
            if(resultAPI.responseData.content.size() > 0){
                List<ContentData> newContents= new List<ContentData>();
                String regexPattern = '^(0084|\\+84|0)';
                for(ContentData item  : resultAPI.responseData.content) {
                    String phoneNumber = item.phoneNumber.replaceFirst(regexPattern, '');
                    List<Contact> contacts = [SELECT Name FROM Contact WHERE Phone =: phoneNumber LIMIT 1];
                        String name = 'No name';
                        if(contacts.size() > 0) name = contacts[0].name;
                        ContentData newContent= new ContentData();
                        newContent.name = name;
                        newContent.phoneNumber = item.phoneNumber;
                        newContent.callTime = item.callTime;
                        newContent.status = item.status;
                        newContents.add(newContent);
                        System.debug('contact' + newContent);  
                }
                resultAPI.responseData.content=newContents;
            }
            return resultAPI;
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static wrapperListAgrentQueue getListAgentQueue(String agentId) {
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'agent-queue-list?agentId='+agentId;
        String authorizationHeader = getAuthorizationHeader();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Accept', '*/*');
        request.setTimeout(10000);
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            System.debug('Response: ' + responseBody);
            wrapperListAgrentQueue resultAPI = (wrapperListAgrentQueue) System.JSON.deserialize(response.getBody(),wrapperListAgrentQueue.class);
            return resultAPI;
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
            return null;
        }
    }

    @AuraEnabled        
    public static wrapperListAgrentStatus getListAgentStatus(String body){
        wrapperListAgrentStatus resultAPI = new wrapperListAgrentStatus();
        String ResponseBody ='';
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'getListAgentStatus';
        String authorizationHeader = getAuthorizationHeader();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', '*/*');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        ResponseBody = response.getBody();
        system.debug('ResponseBody API getAgentStatus ' + ResponseBody);

        if(ResponseBody.length() > 0){
            resultAPI = (wrapperListAgrentStatus) System.JSON.deserialize(ResponseBody, wrapperListAgrentStatus.class);
        }
        return resultAPI;
    }

    private static String getAuthorizationHeader(){
        String username = Soft_Phone__c.getInstance('userAuthSpx').Value__c;
        String password = Soft_Phone__c.getInstance('passwordAuthSpx').Value__c;
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
         return authorizationHeader;
    }

    @AuraEnabled
    public static String OutboundCall(String body,string OutboundListId) {
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'OutboundCall?OutboundListId=' + OutboundListId;
        return  makeHttpRequest('PUT',endpoint,body,null);
    }
    
    private static String makeHttpRequest(String method, String endpoint, String body, Map<String, String> headers) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-API-Key',Soft_Phone__c.getInstance('X_API_KEY').Value__c);
        
        if (headers != null && !headers.isEmpty()) {
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
        }
        
        if (method == 'POST' || method == 'PUT') {
            req.setBody(body);
        }
        
        Http http = new Http();
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            // Response success
            String responseBody = res.getBody();
            System.debug('Response Body: ' + responseBody);
            return responseBody;
        } else {
            // handle error
            System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
            return null;
        }
    }

    @AuraEnabled
    public static List<InfoAgent> getAgentByRegion() {
       List<InfoAgent> result = new List<InfoAgent>();
       
       // lấy Agent ID
       User u = [SELECT id, Id_agent_Using__c from user where Id =: UserInfo.getUserId()];
        
       // Lấy mã danh số của Agent
       Master_Data__c m = [SELECT id, Unit_by_region__c 
                    from Master_Data__c 
                    where Id =: u.Id_agent_Using__c];
        
        // tìm tất cả Agent có cùng khu vực trừ Agent hiện tại
        List<Master_Data__c> mts = [select id, Agent_Id__c, Agent_Code__c
                                    from master_data__c 
                                    where Unit_by_region__c = :m.Unit_by_region__c
                                    AND Id != :u.Id_agent_Using__c
                                    AND Agent_Id__c != null];
        Map<String, InfoAgent> mapAgent = new Map<String, InfoAgent>();
        Set<String> masterDataIds = new Set<String>();
        
        // tạo dữ liệu trả về
        // tạo map để nhập thêm extension từ user
        // tạo list agent id để query user
        for(Master_Data__c mt : mts) {
            InfoAgent iAgent = new InfoAgent();
            iAgent.agentCode = mt.Agent_Code__c;
            iAgent.agentId = mt.Agent_Id__c;
            mapAgent.put(mt.Id, iAgent);
            masterDataIds.add(mt.Id);
            system.debug('mt.Id :' + mt.Id);
        }
        
        // query theo list agent, lấy Extensionid__c
        List<User> lstUser = [SELECT Id, Id_agent_Using__c,name,Extensionid__c FROM User WHERE Id_agent_Using__c IN :masterDataIds];
            system.debug('lstUser :' + lstUser.size());
        if(lstUser.size() > 0){
            for(User iUser: lstUser){
                // gắn thông tin Extensionid__c và add result
                InfoAgent iAgent = mapAgent.get(iUser.Id_agent_Using__c);
                if(iUser.Extensionid__c != null){
                    iAgent.extensionId = iUser.Extensionid__c;
                    iAgent.name = iUser.name;
                    result.add(iAgent);
                }
            }
        }
        System.debug('Response Agent: ' + result);
        return result;
    }

    @AuraEnabled
    public static wrapperGetWallboardReport getWallboardReport(string fromTime, string toTime) {
        User u = [SELECT id, Id_agent_Using__c from user where Id =: UserInfo.getUserId()];
        
        Master_Data__c m = [SELECT id,Management_Unit__c,Partner__c from Master_Data__c where Id =: u.Id_agent_Using__c];
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'report/getWallboardReport' + '?fromTime=' + fromTime + '&toTime=' + toTime + '&teamName=' + m.Management_Unit__c + '&groupName=' + m.Partner__c;
        String authorizationHeader = getAuthorizationHeader();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');
        Http http = new Http();
        HttpResponse response = http.send(req);
        if(response.getStatusCode() == 200){
                String ResponseBody = response.getBody();
            wrapperGetWallboardReport resultAPI = (wrapperGetWallboardReport) System.JSON.deserialize(ResponseBody, wrapperGetWallboardReport.class);
            System.debug('Response Agent: ' + endpoint);
            resultAPI.responseData.managementUnit= m.Management_Unit__c;
            resultAPI.responseData.partner= m.Partner__c;
            return resultAPI;
        }  
        return null;    
    }

    @AuraEnabled
    public static String createCallRecord(String callId,string linkage) {
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'recording/createCallRecord?callId=' + callId + '&linkage=' + linkage;
        String authorizationHeader = getAuthorizationHeader();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        
        Http http = new Http();
        
        HttpResponse res = http.send(req);
        
            // Response success
        String responseBody = res.getBody();
        System.debug('Response Body: ' + responseBody);
        return responseBody;
    }

    @AuraEnabled
    public static String getPbxCallId(String agentId) {
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'recording/getPbxCallId?agentId=' + agentId;
        String authorizationHeader = getAuthorizationHeader();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', authorizationHeader);
        req.setTimeout(10000);
        
        Http http = new Http();
        
        HttpResponse res = http.send(req);
        String responseBody = res.getBody();
        System.debug('Response Body: ' + responseBody);
        return responseBody;
    }

    @AuraEnabled
    public static void updateTask(String taskId, String linkAge) {
        try {
            Task oriTask = [SELECT id, Agent__r.Agent_Id__c
                            FROM Task 
                            WHERE id= :taskId];
            oriTask.Linkage_Id__c = linkAge;
            update oriTask;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled        
    public static String saveTransferCall(String body){
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'saveTransferCall';
        String authorizationHeader = getAuthorizationHeader();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
        
        Http http = new Http();
        
        HttpResponse res = http.send(req);
        
            // Response success
        String responseBody = res.getBody();
        System.debug('Response Body: ' + responseBody);
        return responseBody;
    }


    

    public class wrapperGetWallboardReport{
        @AuraEnabled public String responseCode;	
        @AuraEnabled public String responseMessage;	
        @AuraEnabled public WallboardReport responseData;
    }

    public class WallboardReport{
       @AuraEnabled public string totalDtvAnswering;
       @AuraEnabled public string totalCallOut;
       @AuraEnabled public string totalDtvFreeTime;
       @AuraEnabled public string totalCallAnswered;
       @AuraEnabled public string totalDtvNotready;
       @AuraEnabled public string totalCallDtv;
       @AuraEnabled public string totalCall;
       @AuraEnabled public string totalCallWait;
       @AuraEnabled public string svRatio;
       @AuraEnabled public string svRatio60;
       @AuraEnabled public string managementUnit;
       @AuraEnabled public string partner;
       @AuraEnabled public string tranDi;
       @AuraEnabled public string nhanTran;
       @AuraEnabled public string totalDtvCurrent;
    }
    
    public class ResponseMiddleware{
        @AuraEnabled public String responseCode;	
        @AuraEnabled public String responseMessage;	
        @AuraEnabled public ResponseData responseData;
    }

    public class ResponseData{
        @AuraEnabled public List<ContentData> content;
        @AuraEnabled public boolean last;
    }

    public class ContentData{
        @AuraEnabled public String name;
        @AuraEnabled public String phoneNumber;
        @AuraEnabled public String callTime;
        @AuraEnabled public Integer status;
    }

    public class wrapperListAgrentStatus{
        @AuraEnabled public String responseCode;	
        @AuraEnabled public String responseMessage;	
        @AuraEnabled public List<listAgentStatus> responseData;
    }

    public class listAgentStatus{
        @AuraEnabled public String agentId;
        @AuraEnabled public String agentStatus;
        @AuraEnabled public boolean deleted;
        @AuraEnabled public String workplaceState;
    }

    public class wrapperListAgrentQueue{
        @AuraEnabled public String responseCode;	
        @AuraEnabled public String responseMessage;	
        @AuraEnabled public List<listAgentQueue> responseData;
    }

    public class listAgentQueue{
        @AuraEnabled public String projectName;
        @AuraEnabled public  String inbound;
        @AuraEnabled public String max;
        @AuraEnabled public String outbound;
    }
}