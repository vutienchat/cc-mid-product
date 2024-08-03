/**
* @description       : The Class for bot E ticket
* @author            : ndmanh - GMS
* @last modified on  : 2024.05.31
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@RestResource(urlMapping='/boteticket/*')
global with sharing class R1_CreateTicket {
    @HttpPost
    global static void doPost(){
        Id customerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        
        Savepoint sp = Database.setSavepoint();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String resBody = req.requestBody.toString();
        dataWrapper iTicket = new dataWrapper();
        if(resBody.length() > 0){
            iTicket = (dataWrapper) System.JSON.deserialize(resBody, dataWrapper.class);
        }
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        
        try{
        	Group iOutboundQueue = new Group();
        	if([SELECT Id,Name FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Outbound_Call_Queue'].size() > 0) iOutboundQueue= [SELECT Id,Name FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Outbound_Call_Queue'];
            Contact iCont = [SELECT id FROM Contact 
                             WHERE Phone =: iTicket.phone_number 
                             AND recordtypeId = :customerRT_Id
                             AND Status__c = '1'
                            ];
            
            Case newTicket = new Case();
            newTicket.RecordTypeId = recordTypeId;
            newTicket.Origin = 'Bot';
            newTicket.Subject = iTicket.title;
            newTicket.Status = 'New';
            newTicket.ContactId = iCont.Id;
            newTicket.Description = iTicket.content;
            newTicket.Channel__c = 'bot_channel';
            newTicket.bot_ticket__c = iTicket.ticket_id;
            newTicket.Request_Group__c = iTicket.ticket_type;
            newTicket.Request_Type__c = iTicket.ticket_topic;
            newTicket.Type = iTicket.ticket_type;
            newTicket.Call_Request__c = true;
            if(iOutboundQueue.Name != null) newTicket.OwnerId = iOutboundQueue.Id;
            newTicket.DateTime_Call_Back__c = iTicket.dateTime_Call_Back;
            insert newTicket;
            
            
            valueSet result = new valueSet();
            result.eticket_error_code = '009';
            result.eticket_error_mesage = 'Thành công';
            
            WrapperSetAttributes body = new WrapperSetAttributes();
            body.set_attributes = result;
            //String result = 'Create Case successfully, Case ID: ' + newTicket.Id;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(body));
        } catch (Exception ex) {
            valueSet result = new valueSet();
            result.eticket_error_code = '001';
            result.eticket_error_mesage = ex.getMessage();
            
            WrapperSetAttributes body = new WrapperSetAttributes();
            body.set_attributes = result;
            
            // Rollback transaction in case of error
            Database.rollback(sp);
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(body));
            
            Log_Utils.createLogApiInbound('bot-e-ticket', req, '/api/boteticket/', res);
            System.debug('Exception Message: ' + ex.getMessage());
        }
    }
    
    public class valueSet {
		public String eticket_error_code;
		public String eticket_error_mesage;
	}
	
    public class WrapperSetAttributes {
		public valueSet set_attributes;
	}
    
	
    
    public class dataWrapper {
        public String bot_channel;
        public String sender_name;
        public String sender_id;
        public String phone_number;
        public String ticket_id;
        public String title;
        public String content;
        public String ticket_type;
        public String ticket_topic;
        public String dateTime_Call_Back;
    }
}