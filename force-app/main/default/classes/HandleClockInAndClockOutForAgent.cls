public class HandleClockInAndClockOutForAgent {
    @AuraEnabled        
    public static List<MasterDataWrapper> SearchAgent(){
        
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        
        List<MasterDataWrapper> lstMasterDataWrapper = new List<MasterDataWrapper>();
        List<Master_Data__c> agent = new List<Master_Data__c>();
        List<String> lstAgentId = new List<String>();
        Map<String,String> mapOfAgentIdAndExtensionNumber = new Map<String,String>();
        Map<String,String> mapOfAgentIdAndExtensionId = new Map<String,String>();
        
        String currentMinString;
        Integer currentHour = DateTime.now().hour(); 
        integer currentMin = DateTime.now().minute();
        Integer curentTime;
        
        if(currentMin < 10) {
            currentMinString = '0' + string.valueOf(currentMin);
            curentTime = integer.ValueOf(string.valueOf(currentHour) + currentMinString);
        } else {
            curentTime = integer.ValueOf(string.valueOf(currentHour) + string.valueOf(currentMin));
        }
        
        Id recordTypeId = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        
        List<Work_Management__c> lstWorkShip = [SELECT Id, Agent__c, Clock_in__c, Clock_out__c, User_Using__c, Start_Date__c, End_Date__c, User_Using__r.ExtensionId__c, User_Using__r.Extension_Number__c
                                                FROM Work_Management__c 
                                                WHERE Working_Date__c =: Date.Today() AND User_Using__c =: userInfo.getUserId()
                                                AND RecordTypeId =: idPlan
                                               ];
        
        for(Work_Management__c item : lstWorkShip) {
            lstAgentId.add(item.Agent__c);
            mapOfAgentIdAndExtensionNumber.put(item.Agent__c, item.User_Using__r.Extension_Number__c);
            mapOfAgentIdAndExtensionId.put(item.Agent__c, item.User_Using__r.ExtensionId__c);
        }
        
         
        if(lstWorkShip.size() > 0) {
            agent = [SELECT Id, Name, Phone__c, User_uses__c, User_uses__r.Extension_Number__c ,User_uses__r.ExtensionId__c,  Agent_Code__c, isClockIn__c, isLogin__c, CC_UserName__c, Agent_Id__c, ExtensionId__c, Unit_by_region__c 
                     FROM Master_Data__c 
                     WHERE Id =: lstAgentId 
                     AND RecordTypeId =:recordTypeId];       
        }
        for(Master_data__c item : agent) {
            MasterDataWrapper mtw = new MasterDataWrapper();
            mtw.Name = item.Name + '-' + item.Agent_Code__c;
            mtw.Id = item.Id;
            mtw.Phone = item.Phone__c;
            mtw.isClockIn = item.isClockIn__c;
            mtw.isLogin = item.isLogin__c;
            if(mapOfAgentIdAndExtensionNumber.containsKey(item.Id)) {
                mtw.ExtensionNumber = mapOfAgentIdAndExtensionNumber.get(item.Id);
                mtw.ExtensionId = mapOfAgentIdAndExtensionId.get(item.Id);
            }
            mtw.managerMentUnit = item.Unit_by_region__c.substring(0, 2);
            mtw.partner = item.Unit_by_region__c; 
            mtw.profileName = profileName;
            lstMasterDataWrapper.add(mtw);
        }
        system.debug(lstMasterDataWrapper.size());
        return lstMasterDataWrapper;
    }
    
    //check các agent đang clock-in
    @AuraEnabled        
    public static MasterDataWrapper checkOnlineAgent(){
        
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        MasterDataWrapper mt = new MasterDataWrapper();
        Master_Data__c agent = new Master_Data__c();
        Date todayDate = Date.today();
        List<String> lstAgentId = new List<String>();
        List<Work_Management__c> lstWorkShips = new List<Work_Management__c>();
        
        List<Work_Management__c> lstWorkShip = [SELECT Id, Agent__c, Clock_in__c, Clock_out__c, User_Using__c , User_Using__r.ExtensionId__c
                                                FROM Work_Management__c 
                                                WHERE Working_Date__c =: Date.Today() 
                                                AND User_Using__c =: userInfo.getUserId()
                                                AND RecordTypeId =: idPlan
                                               ];
        
        for(Work_Management__c item : lstWorkShip) {
            lstAgentId.add(item.Agent__c);
        }
        
        if(lstWorkShip.size() > 0) {
            agent = [SELECT Id, Name, Phone__c, User_uses__c, isClockIn__c, isLogin__c, User_uses__r.Extension_Number__c,  Agent_code__c, CC_UserName__c, Agent_Id__c, ExtensionId__c, Shift_inprogress__c FROM Master_Data__c WHERE Id =: lstAgentId AND isClockIn__c = true limit 1];       
            
        }
        
        lstWorkShips = [Select Id, Agent__c, Clock_in__c, Clock_out__c, Channel__c, User_Using__r.ExtensionId__c, User_Using__r.Extension_Number__c
                        From Work_Management__c 
                        Where Id =: agent.Shift_inprogress__c
                       ];
        
        mt.Id = agent.Id;
        mt.Name = agent.Name;
        mt.isClockIn = agent.isClockIn__c;
        mt.Clock_in = lstWorkShips[0].Clock_in__c;
        mt.Phone = agent.Phone__c;
        mt.CCUser = agent.CC_UserName__c;
        mt.isLogin = agent.isLogin__c;
        mt.channel = lstWorkShips[0].Channel__c;
        mt.ExtensionId = lstWorkShips[0].User_Using__r.ExtensionId__c; 
        mt.ExtensionNumber = lstWorkShips[0].User_Using__r.Extension_Number__c; 
        mt.agentCode = agent.Agent_code__c;
        
        return mt;
        
    }
    
    //lấy thông tin agent đã chọn
    @AuraEnabled        
    public static Master_Data__c HandleChooseAgent(String idAgent){
        
        User u = [SELECT Id, Name, ExtensionId__c, Extension_Number__c FROM User WHERE id =: userInfo.getUserId()];
        Master_Data__c agent = [SELECT Id, Name, ExtensionId__c FROM Master_Data__c WHERE Id =: idAgent LIMIT 1];
        
        agent.ExtensionId__c = u.Extension_Number__c;
        update agent;
        return agent;
        
    }
    
    @AuraEnabled        
    public static dataExtension HandleChooseShiftForAgent(String partner){
        String unit;
        String partnerCheck;
        dataExtension dtExtension = new dataExtension(); 
        dtExtension.isFull = 'false'; 
        if(partner != null && partner != '') {
            List<String> splitValue = partner.split('_');
            unit = splitValue[0];
            partnerCheck = splitValue[1];
        }
        
        CC_Workplace__c ccWorkplace;
        
        User u = [SELECT Id, ExtensionId__c, Extension_Number__c 
                  FROM User 
                  WHERE Id =: userInfo.getUserId()];
        
        string idUserUsing = string.valueOf(u.Id); 
        List<CC_Workplace__c> ccWorkplaceCheck = [SELECT Id, Name, Workplace_ID__c,Partner__c, Id_User_Using__c, Management_Unit__c, Reserve_Time__c, Status__c, Extension_ID__c
                                                  FROM CC_Workplace__c
                                                  WHERE Partner__c =: partnerCheck 
                                                  AND Management_Unit__c =: unit 
                                                  AND Id_User_Using__c =: idUserUsing
                                                  AND Status__c = 'Reserved'
                                                  LIMIT 1];
        
        if(ccWorkplaceCheck.size() > 0) {
            ccWorkplace = ccWorkplaceCheck[0];
        } else {
            List<CC_Workplace__c> ccWorkplaceCheckRandom = [SELECT Id, Name, Workplace_ID__c,Partner__c, Id_User_Using__c, Management_Unit__c, Reserve_Time__c, Status__c, Extension_ID__c
                                                            FROM CC_Workplace__c
                                                            WHERE Partner__c =: partnerCheck 
                                                            AND Management_Unit__c =: unit 
                                                            AND Status__c = 'Available'
                                                            LIMIT 1];
            if(ccWorkplaceCheckRandom.size() > 0) {
                ccWorkplace = ccWorkplaceCheckRandom[0];
            }
            else {
                dtExtension.isFull = 'true'; 
            }
        }
        
        if(dtExtension.isFull == 'false') {
            
            
            ccWorkplace.Reserve_Time__c = Datetime.now();
            ccWorkplace.Status__c = 'Reserved';
            ccWorkplace.Id_User_Using__c = u.Id;
            update ccWorkplace;
            
            /*
String requestBody = JSON.serialize(new Map<String, Object>{
'workplaceId' => ccWorkplace.Workplace_ID__c
});

string responseData;
if(requestBody != null){
HttpResponse result = GMS_CallApiGateway.callApi('check Stage for agent','sf-api/v1/frontstage/check-status-workplace','POST',requestBody,'');
responseData = result.getBody().toString();
apiResponseStatus res = (apiResponseStatus) System.JSON.deserialize(responseData, apiResponseStatus.class);


if(res.data.used == true) {
User u = [SELECT Id, ExtensionId__c, Extension_Number__c 
FROM User 
WHERE Id =: userInfo.getUserId()];

u.ExtensionId__c = ccWorkplace.Extension_ID__c;
u.Extension_Number__c = ccWorkplace.Name;
update u;
dtExtension.extensionNumber = u.Extension_Number__c;
dtExtension.WorkplaceId = ccWorkplace.Workplace_ID__c;
} else { 
HandleChooseShiftForAgent(partner); 
}
}
*/
            
            
            u.ExtensionId__c = ccWorkplace.Extension_ID__c;
            u.Extension_Number__c = ccWorkplace.Name;
            update u;
            dtExtension.extensionNumber = u.Extension_Number__c;
            dtExtension.WorkplaceId = ccWorkplace.Workplace_ID__c;
        }
        return dtExtension;
        
    }
    
    //Update khi agent clock-in
    @AuraEnabled        
    public static MasterDataWrapper UpdateClockIn(String idAgent, String valueCheck, String workplaceId){
        
        Id idActual = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Actual').getRecordTypeId();
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        Id idWorkEntry = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Work_Entry').getRecordTypeId();
        
        
        String currentMinString;
        Integer currentHour = DateTime.now().hour(); 
        integer currentMin = DateTime.now().minute();
        Integer curentTime;
        
        if(currentMin < 10) {
            currentMinString = '0' + string.valueOf(currentMin);
            curentTime = integer.ValueOf(string.valueOf(currentHour) + currentMinString);
        } else {
            curentTime = integer.ValueOf(string.valueOf(currentHour) + string.valueOf(currentMin));
        }
        
        system.debug(curentTime);
        Date todayDate = Date.today();
        MasterDataWrapper mt = new MasterDataWrapper();
        
        //User_uses__c =: userInfo.getUserId() AND
        Master_Data__c agent = [SELECT Id, Name, Phone__c, User_uses__c, ExtensionId__c, Agent_code__c, isClockIn__c, isLogin__c, CC_UserName__c, Agent_Id__c, Shift_inprogress__c 
                                FROM Master_Data__c 
                                WHERE Id =: idAgent Limit 1];
        
        List<Work_Management__c> lstWorkShip;
        
        lstWorkShip = [Select Id, Agent__c, Clock_in__c, Clock_out__c, Key__c , Channel__c, Start_Date__c, End_Date__c
                       From Work_Management__c 
                       Where Agent__c =:idAgent 
                       And Working_Date__c =: todayDate
                       And RecordTypeId =: idPlan
                      ];
        
        User u = new User();
        u.Id = userInfo.getUserId();
        u.Id_Agent_Using__c = idAgent;
        if(lstWorkShip.size() > 0) {
            if(valueCheck == 'kenhso') {
                lstWorkShip[0].Channel__c = 'Kênh số';
                
            } else {
                lstWorkShip[0].Channel__c = 'Kênh thoại';
            }
        }
        lstWorkShip[0].Clock_in__c = Datetime.now();
        agent.isClockIn__c = true; 
        agent.Shift_inprogress__c = lstWorkShip[0].Id;
        
        mt.Id = agent.Id;
        mt.Name = agent.Name;
        mt.isClockIn = agent.isClockIn__c;
        mt.Clock_in = lstWorkShip[0].Clock_in__c;
        mt.Phone = agent.Phone__c;
        mt.CCUser = agent.CC_UserName__c;
        //mt.isLogin = agent.isLogin__c;
        mt.ExtensionId = agent.ExtensionId__c;
        mt.channel = lstWorkShip[0].Channel__c; 
        mt.agentCode = agent.Agent_code__c;
        
        getAgentStatusWrapper resultAPI = getAgentStatus(agent.Agent_Id__c);
        //system.debug('resultAPI.responseData.agentStatus :' + resultAPI.responseData.agentStatus);
        if(resultAPI.responseData.agentStatus != '$Cmn_LogOff' || valueCheck == 'kenhso') {
            List<Work_Management__c> w = [Select Id, Agent__c, Clock_in__c, Clock_out__c, shift__c, Working_Date__c, User_Using__c, Key__c From Work_Management__c Where key__c =: lstWorkShip[0].Key__c and recordTypeId =: idActual];
            mt.isLogin = true;
            update u;
            update agent; 
            update lstWorkShip[0];
            
            if(workplaceId != null && workplaceId != '') {
                CC_Workplace__c ccWorkplace = [SELECT Id, Name, Workplace_ID__c,Partner__c, Management_Unit__c, Reserve_Time__c, Status__c, Extension_ID__c
                                               FROM CC_Workplace__c
                                               WHERE Workplace_ID__c =: workplaceId 
                                              ];
                
                if(ccWorkplace != null) {
                    ccWorkplace.Status__c = 'Used'; 
                    update ccWorkplace;
                }
            }
        }
        return mt; 
    }
    @AuraEnabled        
    public static MasterDataWrapper UpdateClockOut(String idAgent , String valueCheck, String workplaceId){
        
        Id idActual = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Actual').getRecordTypeId();
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        Id idWorkEntry = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Work_Entry').getRecordTypeId();
        
        DateTime todayDate = DateTime.Now(); 
        Decimal Duration = 0;
        
        //User_uses__c =: userInfo.getUserId() AND
        Master_Data__c agent = [SELECT Id, Name, Phone__c, User_uses__c, isClockIn__c, isLogin__c,CC_UserName__c, Agent_Id__c, Shift_inprogress__c
                                FROM Master_Data__c 
                                WHERE Id =: idAgent Limit 1];
        
        List<Work_Management__c> lstWorkShip = [Select Id, Agent__c, Clock_in__c, Clock_out__c, shift__c, Working_Date__c, User_Using__c, key__c, Channel__c 
                                                From Work_Management__c 
                                                Where id =: agent.Shift_inprogress__c 
                                               ];
        
        
        User u = new User();
        u.Id = userInfo.getUserId();
        u.Id_Agent_Using__c = '';
        u.Extension_Number__c = '';
        u.ExtensionId__c = '';
        
        agent.isClockIn__c = false; 
        agent.Shift_inprogress__c = '';
        MasterDataWrapper mt = new MasterDataWrapper();
        mt.Id = agent.Id;
        mt.Name = agent.Name;
        mt.isClockIn = agent.isClockIn__c;
        mt.Clock_in = lstWorkShip[0].Clock_in__c;
        mt.Phone = agent.Phone__c;
        mt.CCUser = agent.CC_UserName__c;
        lstWorkShip[0].Clock_out__c = DateTime.Now();
        
        getAgentStatusWrapper resultAPI ;  
        
        resultAPI = getAgentStatus(agent.Agent_Id__c);
        if(resultAPI.responseData.agentStatus == '$Cmn_LogOff' || lstWorkShip[0].Channel__c == 'Kênh số') {
            mt.isLogin = false;
            List<Work_Management__c> w = [Select Id, Agent__c, Clock_in__c, Clock_out__c, shift__c, Working_Date__c, User_Using__c, Key__c 
                                          From Work_Management__c 
                                          Where key__c =: lstWorkShip[0].Key__c 
                                          and recordTypeId =: idActual];
            
            if(lstWorkShip.size() > 0) {
                Work_Management__c WorkEntry = lstWorkShip[0].clone(false, false, false, false);
                WorkEntry.recordTypeId = idWorkEntry;
                insert WorkEntry;
            }
            
            List<Work_Management__c> lstWorkShipEntry = [Select Id, Agent__c, Clock_in__c, Number_of_hours_worked__c,  Clock_out__c, shift__c, Working_Date__c, User_Using__c, key__c 
                                                         From Work_Management__c 
                                                         Where key__c =: lstWorkShip[0].Key__c and recordTypeId =: idWorkEntry
                                                        ];
            
            
            if(lstWorkShipEntry.size() > 0) {
                for(Work_Management__c ws : lstWorkShipEntry) {
                    if(ws.Number_of_hours_worked__c != null) {
                        Duration += ws.Number_of_hours_worked__c; 
                    }
                }
            }
            
            if(w.size() > 0) {
                w[0].Clock_out__c = todayDate;
                w[0].Duration__c = Duration; 
                update w;
            }
            else {
                Work_Management__c workShipActual = lstWorkShip[0].clone(false, false, false, false);
                workShipActual.recordTypeId = idActual;
                insert workShipActual; 
            }
            update u;
            update agent; 
            update lstWorkShip[0];
            
            if(workplaceId != null && workplaceId != '') {
                CC_Workplace__c ccWorkplace = [SELECT Id, Name, Workplace_ID__c,Partner__c, Management_Unit__c, Reserve_Time__c, Status__c, Extension_ID__c
                                               FROM CC_Workplace__c
                                               WHERE Extension_ID__c =: workplaceId 
                                               LIMIT 1
                                              ];
                
                system.debug(ccWorkplace);
                if(ccWorkplace != null) {
                    ccWorkplace.Status__c = 'Available';
                    ccWorkplace.Id_User_Using__c = '';
                    update ccWorkplace;
                }
                
            }
        }
        
        return mt;
    } 
    
    @AuraEnabled        
    public static getAgentStatusWrapper getAgentStatus(String idAgent){
        getAgentStatusWrapper resultAPI = new getAgentStatusWrapper();
        // call API getAgentStatus
        String ResponseBody ='';
        String endpoint = Soft_Phone__c.getInstance('endpoint_middleware').Value__c;
        endpoint = endpoint + 'getAgentStatus?agentId=' + idAgent;
        String username = Soft_Phone__c.getInstance('userAuthSpx').Value__c;
        String password = Soft_Phone__c.getInstance('passwordAuthSpx').Value__c;
        
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
        system.debug('ResponseBody API getAgentStatus ' + ResponseBody);
        
        if(ResponseBody.length() > 0){
            resultAPI = (getAgentStatusWrapper) System.JSON.deserialize(ResponseBody, getAgentStatusWrapper.class);
        }
        return resultAPI;
    } 
    
    public class getAgentStatusWrapper{
        @AuraEnabled public String responseCode;	//200
        @AuraEnabled public String responseMessage;	//Thành công
        @AuraEnabled public responseData responseData;
    }
    
    public class responseData {
        @AuraEnabled public String agentId;	//2a00d624-ee7d-4736-bb11-0e70a373e243
        @AuraEnabled public String agentStatus;	//$Cmn_Ready
        @AuraEnabled public boolean deleted;
    }
    
    public class MasterDataWrapper{
        @AuraEnabled 
        public String Id {get;set;} 
        @AuraEnabled 
        public String Name {get;set;} 
        @AuraEnabled
        public Boolean isClockIn {get;set;}
        @AuraEnabled 
        public DateTime Clock_in {get;set;}
        @AuraEnabled 
        public String Phone {get;set;}
        @AuraEnabled 
        public Boolean isLogin {get;set;}
        @AuraEnabled 
        public String CCUser {get;set;}
        @AuraEnabled 
        public String channel {get;set;}
        @AuraEnabled 
        public String ExtensionId {get;set;}
        @AuraEnabled 
        public String ExtensionNumber {get;set;}
        @AuraEnabled 
        public String agentCode {get;set;}
        @AuraEnabled 
        public String profileName {get;set;} 
        @AuraEnabled 
        public String partner {get;set;} 
        @AuraEnabled 
        public String managerMentUnit {get;set;} 
    }
    
    public class apiResponseStatus {
        @AuraEnabled 
        public Data data;
        @AuraEnabled 
        public Integer http_code;
        @AuraEnabled 
        public String text;
        @AuraEnabled 
        public Integer error_code;
    }
    public class Data {
        @AuraEnabled 
        public Boolean used;
    }
    
    public class dataExtension {
        @AuraEnabled 
        public String ExtensionNumber;
        @AuraEnabled 
        public String WorkplaceId;
        @AuraEnabled 
        public String Status;
        @AuraEnabled
        public String isFull;
    }
    
    
}