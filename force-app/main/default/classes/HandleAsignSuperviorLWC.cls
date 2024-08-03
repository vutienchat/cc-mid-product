/**
* @description       : The Class for Handle LWC asign Supervior
* @author            : DTDuong - GMS
* @create time	     : 2024.05.21
* @last modified on  : 2024.06.01
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

public without sharing class HandleAsignSuperviorLWC {
    
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getOptionUnits() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Master_Data__c').getDescribe().fields.getMap().get('Unit_by_region__c').getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            if (entry.isActive()) {
                options.add(new OptionWrapper(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getOptionTeams() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Master_Data__c').getDescribe().fields.getMap().get('Team__c').getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            if (entry.isActive()) {
                options.add(new OptionWrapper(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getOptionTypes() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Task').getDescribe().fields.getMap().get('Type').getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            if (entry.isActive()) {
                options.add(new OptionWrapper(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getOptionReason() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Task').getDescribe().fields.getMap().get('Reason__c').getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            if (entry.isActive()) {
                options.add(new OptionWrapper(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }
    
    // add 13/6
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getOptionSupervisor(String idUnit, String type) {
        List<OptionWrapper> options = new List<OptionWrapper>();
        List<Master_Data__c> listOptionsSupervisor;
        system.debug(type);
        // Logic to populate listOptionsAgent based on idUnit
        if(type == '2'){
            if (idUnit != null && idUnit != '') {
                listOptionsSupervisor = [SELECT Id, Name FROM Master_Data__c WHERE Unit_by_region__c = :idUnit and Role__c = 'GSV'];
            } else {
                listOptionsSupervisor = [SELECT Id, Name FROM Master_Data__c WHERE Role__c = 'GSV'];
            }
        } else {
            listOptionsSupervisor = [SELECT Id, Name FROM Master_Data__c WHERE Role__c = 'GSV'];
        }
        for (Master_Data__c md : listOptionsSupervisor) {
            options.add(new OptionWrapper(md.Name, md.Id));
        }

        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getOptionAgents(String idUnit, String type) {
        List<OptionWrapper> options = new List<OptionWrapper>();
        List<Master_Data__c> listOptionsAgent;
        system.debug(type);
        // Logic to populate listOptionsAgent based on idUnit
        if(type == '1'){
            if (idUnit != null && idUnit != '') {
                listOptionsAgent = [SELECT Id, Name FROM Master_Data__c WHERE RecordType.DeveloperName = 'Agent' AND Unit_by_region__c = :idUnit and Role__c != 'GSV'];
            } else {
                listOptionsAgent = [SELECT Id, Name FROM Master_Data__c WHERE RecordType.DeveloperName = 'Agent' and Role__c != 'GSV'];
            }
        } else {
            listOptionsAgent = [SELECT Id, Name FROM Master_Data__c WHERE RecordType.DeveloperName = 'Agent' and Role__c = 'GSV'];
        }
        for (Master_Data__c md : listOptionsAgent) {
            options.add(new OptionWrapper(md.Name, md.Id));
        }

        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getTemplate() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        List<Survey_Template__c> survey_template = [Select Id, Name from Survey_Template__c where RecordType.DeveloperName = 'Agent_Scoring'];
        
        for (Survey_Template__c md : survey_template) {
            options.add(new OptionWrapper(md.Name, md.Id));
        }

        return options;
    }
    
    // add 02/07
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getRecordTypeOfCase() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        List<RecordType> recordTypeCase = [Select Id,Name from RecordType where sObjectType='Case'];
        for (RecordType item : recordTypeCase) {
        	options.add(new OptionWrapper(item.Name, item.Id));
        }
        return options;
    }

    @AuraEnabled
    public static List<DataListWapper> getDataList(ListRequest request, Boolean checkTime, String field, String sortOrder){
        system.debug(request.toString());
		Datetime timeStart = request.timeStart;
        Datetime timeEnd = request.timeEnd;
        List<DataListWapper> dataList = new List<DataListWapper>();
        String condition = '';
        String OrderBy = ' ORDER BY CreatedDate DESC';

        if(checkTime){
            condition = 'AND Survey_Result__c != null AND Survey_Result__r.Supervisor_1__c != null AND Survey_Result__r.Supervisor_2__c = null AND Survey_Result__r.Status__c != \'Done\' ';
        } else {
            condition = 'AND Survey_Result__c = null ';
        }
        if(request.agent.size() > 0){
            List<String> agent = request?.agent;
            condition += 'AND Agent__r.Id in :agent ';
        }
        if(String.isNotBlank(request.unit)){
            String unit = request?.unit;
            condition += 'AND Agent__r.Unit_by_region__c = :unit ';
        }
        if(request.team.size() > 0){
            List<String> team = request?.team;
            condition += 'AND Agent__r.Team__c = :team';
        }
        
        if(String.isNotBlank(request.supervisor)){
            condition += 'AND Survey_Result__r.Supervisor_1__c = :request.supervisor ';
        }
        try {
            if(request.zalo == true){
                String queryZalo = 'SELECT LastModifiedDate, gmscloud__Status__c, gmscloud__Channel__c, CreatedDate, gmscloud__EndTime__c, gmscloud__ChatDuration__c, Owner.Name, Id,Agent__c ' +
                                   'FROM gmscloud__GMS_Chat_Transcription__c ' +
                                   'WHERE gmscloud__Status__c = \'Completed\' ';
                if(timeStart != null){
                    queryZalo += 'AND CreatedDate > :timeStart ';
                }
                if(timeEnd != null){ 
                    queryZalo += 'AND CreatedDate < :timeEnd ';
                }  
                queryZalo += condition;
                queryZalo += OrderBy;
                List<gmscloud__GMS_Chat_Transcription__c> listZalo = Database.query(queryZalo);                                                                    
                for (gmscloud__GMS_Chat_Transcription__c item : listZalo) {
                    dataList.add(new DataListWapper(
                        '', 
                        'Zalo',
                        item?.gmscloud__Channel__c?.toString(),
                        item?.LastModifiedDate?.toString(),
                        '',
                        item?.gmscloud__Status__c?.toString(),
                        item?.CreatedDate?.toString(),
                        item?.gmscloud__EndTime__c?.toString(),
                        item?.gmscloud__ChatDuration__c?.toString(),
                        item?.Owner?.Name?.toString(),
                        item?.Id.toString(),
                        item?.Agent__c?.toString(),
                        ''
                    ));
                }
            }
            if(request.chatbot == true){
                String queryChatbot = 'SELECT GMS_Lab_FPT__Chat_Bot_Channel__c, LastModifiedDate, GMS_Lab_FPT__Status__c, CreatedDate, GMS_Lab_FPT__End_Time__c, Owner.Name, Id, Agent__c ' +
                     'FROM GMS_Lab_FPT__Chat_Transcription__c ' +
                     'WHERE GMS_Lab_FPT__Status__c = \'Ended by agent\' ';
                if(timeStart != null){
                    queryChatbot += 'AND CreatedDate > :timeStart ';
                }
                if(timeEnd != null){
                    queryChatbot += 'AND CreatedDate < :timeEnd '; 
                }  
				queryChatbot += condition;
                queryChatbot += OrderBy;
				List<GMS_Lab_FPT__Chat_Transcription__c> listChatBot = Database.query(queryChatbot);
                for (GMS_Lab_FPT__Chat_Transcription__c item : listChatBot) {
                    dataList.add(new DataListWapper(
                        '',
                        'Chatbot',
                        item?.GMS_Lab_FPT__Chat_Bot_Channel__c?.toString(),
                        item?.LastModifiedDate?.toString(),
                        '',
                        item?.GMS_Lab_FPT__Status__c?.toString(),
                        item?.CreatedDate?.toString(),
                        item?.GMS_Lab_FPT__End_Time__c?.toString(),
                        '',
                        item?.Owner?.Name?.toString(),
                        item?.Id.toString(),
                        item?.Agent__c?.toString(),
                        ''
                    ));
                }
            }
            if(request.facebook == true){
                String queryFacebook = 'SELECT LastModifiedDate, MessagingChannel.MasterLabel, Status, StartTime, EndTime, MessagingEndUser.Name, Id, Agent__c ' +
                                     'FROM MessagingSession ' +
                                     'WHERE Status = \'Ended\' ';                   
                if(timeStart != null){
                    queryFacebook += 'AND StartTime > :timeStart ';
                }  
                if(timeEnd != null){
                    queryFacebook += 'AND StartTime < :timeEnd ';
                }  
                queryFacebook += condition;
                queryFacebook += OrderBy;
                system.debug(queryFacebook);
                List<MessagingSession> listFacebook = Database.query(queryFacebook);
                system.debug(listFacebook.size());
                for (MessagingSession item : listFacebook) {
                    dataList.add(new DataListWapper(
                        '',
                        'Facebook',
                        item?.MessagingChannel.MasterLabel?.toString(),
                        item?.LastModifiedDate?.toString(),
                        '',
                        item?.Status,
                        item?.StartTime?.toString(),
                        item?.EndTime?.toString(),
                        '',
                        item?.MessagingEndUser.Name?.toString(),
                        item?.Id.toString(),
                        item?.Agent__c?.toString(),
                        ''
                    ));
                }
            }
            if(request.task == true){
                String agentLevel = request?.agentLevel;
                Integer timeCall = request?.timeCall;
                Integer timeCallEnd = request?.timeCallEnd;
                String queryTask = 'SELECT Phone__c, Type, LastModifiedDate, What.RecordType.Name, Status, Start_Time__c, End_Time__c, Call_duration__c, Agent__r.Name, Id, Agent__c,Survey_Result__r.Supervisor_1__r.Agent_Name__c ' +
                     'FROM Task WHERE ' + 
                     '(Agent__r.Callin_skill__c = :agentLevel OR Agent__r.Callout_skill__c = :agentLevel OR Agent__r.Chat_skill__c = :agentLevel) ';
                if(timeCall != null){
                    queryTask += 'AND Call_duration__c >= :timeCall ';
                } 
                if(timeCallEnd != null){
                    queryTask += 'AND Call_duration__c <= :timeCallEnd ';
                } 
                if(timeStart != null){
                    queryTask += 'AND Start_Time__c > :timeStart ';
                } 
                if(timeEnd != null){
                    queryTask += 'AND Start_Time__c < :timeEnd ';
                } 
                if(String.isNotBlank(request.caseType)){
                    String caseType = request?.caseType;
                    queryTask += 'AND What.RecordTypeId = :caseType AND What.Type = \'Case\' ';
                } 
                if(String.isNotBlank(request.type)) {
                    String type = request?.type;
                    queryTask += ' AND Type = :type ';
                }
                if(String.isNotBlank(request.reason)) {
                    String reason = request?.reason;
                    queryTask += ' AND Type = :reason ';
                }
				queryTask += condition; 
                queryTask += OrderBy;
                system.debug(queryTask);
				List<Task> listTask = Database.query(queryTask);
                system.debug(listTask.size());
                for (Task item : listTask) {
                    dataList.add(new DataListWapper(
                        item?.Phone__c, 
                        'Task',
                        item?.Type,
                        item?.LastModifiedDate?.toString(),
                        item?.What?.RecordType?.Name?.toString(),
                        item?.Status,
                        item?.Start_Time__c?.toString(),
                        item?.End_Time__c?.toString(),
                        item?.Call_duration__c?.toString(),
                        item?.Agent__r?.Name?.toString(),
                        item?.Id.toString(),
                   		item?.Agent__c?.toString(),
                        item?.Survey_Result__r?.Supervisor_1__r?.Agent_Name__c?.toString()
                    ));
                }
            }
            Integer totalRecords = dataList.size();
        	Integer numRecordsToReturn = (Integer)Math.ceil(totalRecords * (request.percentOfData / 100.0));
            if(request.NumberCall > 0){
                
            }
            List<DataListWapper> selectedDataList = new List<DataListWapper>();
            while(selectedDataList.size() < numRecordsToReturn && !dataList.isEmpty()){
                Integer randomIndex = Math.floor(Math.random() * dataList.size()).intValue();
                selectedDataList.add(dataList.remove(randomIndex));
            }
            return selectedDataList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Boolean asignData(List<SelectAsignWapper> selectData, ListAsignData data) {
        system.debug(selectData.toString());
        system.debug(data);
        List<Survey_Result__c> upsertListSurveyResult = new List<Survey_Result__c>();
        List<Task> listUpdateTask = new List<Task>();
        List<MessagingSession> listUpdateMess = new List<MessagingSession>();
        List<GMS_Lab_FPT__Chat_Transcription__c> listUpdateChatBot = new List<GMS_Lab_FPT__Chat_Transcription__c>();
        List<gmscloud__GMS_Chat_Transcription__c> listUpdateZalo = new List<gmscloud__GMS_Chat_Transcription__c>();
        Set<String> recipientsIds = new Set<String>();
        // String idAgent = data.supervior;  // Ensure the variable name is correct
        // List<Master_data__c> resultUser = [SELECt User_uses__c from Master_Data__c where Id = :idAgent LIMIT 1];
        // if (!resultUser.isEmpty()) {
        //   recipientsIds.add(resultUser[0].User_uses__c);
        // }
       	Integer countZalo = 0;
        Integer countFacebook = 0;
        Integer countChatbot = 0;
        Integer countTask = 0;
        for(SelectAsignWapper item: selectData){
            Survey_Result__c insertSurveyResult = new Survey_Result__c();
            insertSurveyResult.Target_Id__c = item.id.toString();
            system.debug('timeAsign :' + data.timeAsign);
            if(data.timeAsign == '1'){
                insertSurveyResult.Survey_Template__c = data.template;
                // insertSurveyResult.Supervisor_1__c = data.supervior;
                insertSurveyResult.Supervisor_1__c = getRandomItem(data.supervior);
                system.debug('test333' + insertSurveyResult.Supervisor_1__c.toString());
                insertSurveyResult.Status__c = 'Not_scored';
                insertSurveyResult.Exprie_date__c = data.exprieDate;
                if(!String.isBlank(item.idAgent)){
                    insertSurveyResult.Scoring_Agent__c = item.idAgent;
                }
            } else {
                // insertSurveyResult.Supervisor_2__c = data.supervior;
                insertSurveyResult.Supervisor_2__c = getRandomItem(data.supervior);
            }
            insertSurveyResult.Type_Object__c = item.typeObject.toString();
            upsertListSurveyResult.add(insertSurveyResult);
        }
        if(upsertListSurveyResult.size() > 0){
            upsert upsertListSurveyResult Target_Id__c;
            for(Survey_Result__c item : upsertListSurveyResult){
                if(item.Type_Object__c == 'Task'){
                    countTask++;
                    Task updateTask = new Task();
                    updateTask.id = item.Target_Id__c;
                    updateTask.Survey_Result__c = item.id;
                    listUpdateTask.add(updateTask);
                }
                if(item.Type_Object__c == 'Facebook'){
                    countFacebook++;
                    MessagingSession updateMesaging = new MessagingSession();
                    updateMesaging.id = item.Target_Id__c;
                    updateMesaging.Survey_Result__c = item.id;
                    listUpdateMess.add(updateMesaging);
                }
                if(item.Type_Object__c == 'Chatbot'){
                    countChatbot++;
                    GMS_Lab_FPT__Chat_Transcription__c updateChatBot = new GMS_Lab_FPT__Chat_Transcription__c();
                    updateChatBot.id = item.Target_Id__c;
                    updateChatBot.Survey_Result__c = item.id;
                    listUpdateChatBot.add(updateChatBot);
                }
                if(item.Type_Object__c == 'Zalo'){
                    countZalo++;
                    gmscloud__GMS_Chat_Transcription__c updateZalo = new gmscloud__GMS_Chat_Transcription__c();
                    updateZalo.id = item.Target_Id__c;
                    updateZalo.Survey_Result__c = item.id;
                    listUpdateZalo.add(updateZalo);
                }
            }
            if(listUpdateTask.size() > 0) update listUpdateTask;
            if(listUpdateMess.size() > 0) update listUpdateMess;
            if(listUpdateChatBot.size() > 0) update listUpdateChatBot;
            if(listUpdateZalo.size() > 0) update listUpdateZalo;
            //if(recipientsIds.size() > 0){
            //    sendNotificationForSupervior(recipientsIds,countZalo,countFacebook,countChatbot,countTask);
            //}
            return true;
        } else {
            return false;
        }
    }
    
    public static String getRandomItem(List<String> listString) {
        Integer n = listString.size();
        if (n == 0) {
            return null; // Handle the empty array case appropriately
        }
        Integer randomIndex = Math.floor(Math.random() * n).intValue();
        return listString[randomIndex];
    }

    /*
    public static void sendNotificationForSupervior(Set<String> recipientsIds, Integer countZalo, Integer countFacebook, Integer countChatbot, Integer countTask) {

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='NotiWhenAsignSupervior'];
        // Set the contents for the notification
        notification.setTitle('Thông báo');
        String body = 'Bạn được giao chấm điểm: ';
        if(countZalo > 0){
            body += countZalo.toString() + ' bản ghi Zalo';
        }
        if(countFacebook > 0){
            body += countFacebook.toString() + ' bản ghi Facebook';
        }
        if(countChatbot > 0){
            body += countChatbot.toString() + ' bản ghi Chatbot';
        }
        if(countTask > 0){
            body += countTask.toString() + ' bản ghi Task';
        }
        system.debug(body);
        notification.setBody(body);

        // Set the notification type and target
        notification.setNotificationTypeId('0MLH200000006oCOAQ');
        system.debug(notificationType.Id);
        // notification.setTargetId('005H2000006OADrIAO');
        Map<String, String> targetPageRef = new Map<String, String>();
        targetPageRef.put('type', 'standard__webPage');
        targetPageRef.put('attributes', '{"url":"https://flow-force-2116--mbfdev.sandbox.lightning.force.com/lightning/o/Survey_Result__c/list?filterName=All"}');
        notification.setTargetPageRef(JSON.serialize(targetPageRef));
        // Actually send the notification
        try {
            notification.send(recipientsIds);
            system.debug('333');
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        } 
    }
    */
    public class OptionWrapper {
        @AuraEnabled
        public String Label { get; set; }
        @AuraEnabled
        public String Value { get; set; }

        public OptionWrapper(String label, String value) {
            this.Label = label;
            this.Value = value;
        }
    }

    public class DataListWapper {
        @AuraEnabled
        public String phone { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public String typeTask { get; set; }
        @AuraEnabled
        public String endDay { get; set; }
        @AuraEnabled
        // public String startDay { get; set; }
        public String typeCase { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public String startTime { get; set; }
        @AuraEnabled
        public String endTime { get; set; }
        @AuraEnabled
        public String duration { get; set; }
        @AuraEnabled
        public String owner { get; set; }
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String idAgent { get; set; }
        @AuraEnabled
        public String supervior_1 { get; set; }

        public DataListWapper(String phone, String type, String typeTask, String endDay, String typeCase, String status, String startTime, String endTime, String duration, String owner, String id, String idAgent, String supervior_1) {
            this.phone = phone;
            this.type = type;
            this.typeTask = typeTask;
            this.endDay = endDay;
            this.typeCase = typeCase;
            this.status = status;
            this.startTime = startTime;
            this.endTime = endTime;  
            this.duration = duration;
            this.owner = owner;
            this.id = id;
            this.idAgent = idAgent;
            this.supervior_1 = supervior_1;
        }
    }

    public class ListRequest {
        @AuraEnabled
        public String unit { get; set; }
        @AuraEnabled
        public List<String> team { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public List<String> agent { get; set; }
        @AuraEnabled
        public Boolean zalo { get; set; }
        @AuraEnabled
        public Boolean facebook { get; set; } 
        @AuraEnabled
        public Boolean task { get; set; }
        @AuraEnabled
        public Boolean chatbot { get; set; }
        @AuraEnabled
        public integer percentOfData { get; set; }
        @AuraEnabled
        public integer timeCall { get; set; }
        @AuraEnabled
        public integer timeCallEnd { get; set; }
        @AuraEnabled
        public string agentLevel { get; set;}
     	@AuraEnabled
        public String typeObject { get; set;} // check type của Task, Mess, Zalo, Chatbot
        @AuraEnabled
        public Datetime timeStart { get; set;}
        @AuraEnabled
        public Datetime timeEnd { get; set;}
        @AuraEnabled
        public String supervisor { get; set; }
        @AuraEnabled
        public integer numberCall { get; set;}
        @AuraEnabled
        public string reason { get; set;}
        @AuraEnabled
        public string caseType { get; set;}
    }
    
    public class SelectAsignWapper {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String typeObject { get; set; }
        @AuraEnabled
        public String idAgent { get; set; }
        
        public SelectAsignWapper() {}

        public SelectAsignWapper(String id, String typeObject, String idAgent) {
            this.id = id;
            this.typeObject = typeObject;
            this.idAgent = idAgent;
        }
    }

    public class ListAsignData {
        @AuraEnabled
        public List<String> supervior { get; set; }
        @AuraEnabled
        public String template { get; set; }
        @AuraEnabled
        public String timeAsign { get; set; }
        @AuraEnabled
        public Date exprieDate { get; set; }
        
        public ListAsignData() {}

        public ListAsignData(List<String> supervior, String template, String timeAsign, Date exprieDate) {
            this.supervior = supervior;
            this.template = template;
            this.timeAsign = timeAsign;
            this.exprieDate = exprieDate;
        }
    }
}