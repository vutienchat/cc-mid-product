/**
* @description       : The Class for API Create Contact from Omni DB
* @author            : ndmanh - GMS
* @last modified on  : 2024.06.04
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@RestResource(urlMapping='/createContact/job/*')
global with sharing class R1_CreateContact {
    @HttpPost
    global static void doPost(){
        Savepoint sp = Database.setSavepoint();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String resBody = req.requestBody.toString();
        
        List<Contact> lstUpsert = new List<Contact>();
        List<valueSet> body = new List<valueSet>();
        List<dataWrapper> wrapperList = new List<dataWrapper>();
        system.debug(resBody);
        
        Id customerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        
        if(resBody.length() > 0){
            wrapperList = (List<dataWrapper>) JSON.deserialize(resBody, List<dataWrapper>.class);
            // ibody = (List<dataWrapper>) System.JSON.deserialize(resBody, List<dataWrapper>.class);
        }
        
        try{
            if(wrapperList.size() > 0){
                for(dataWrapper item: wrapperList){
                    Contact iCont = new Contact();
                    iCont.RecordTypeId = customerRT_Id;
                    if( item.CONTACT_ID != null )			iCont.Id 						= item.CONTACT_ID;
					if( item.ACCOUNT_ID != null ) 			iCont.AccountId 				= item.ACCOUNT_ID;
                    if( item.SERVICE_CATEGORY_ID != null ) 	iCont.Service_Category__c 		= item.SERVICE_CATEGORY_ID;
                    if( item.ISDN != null ) 				iCont.Phone 					= item.ISDN;
                    if( item.SUB_ID != null ) 				iCont.Sub_Id__c 				= item.SUB_ID;
                    if( item.STATUS != null ) 				iCont.Status__c 				= item.STATUS;
                    if( item.PAY_METHOD != null ) 			iCont.Pay_Method__c 			= item.PAY_METHOD;
                    if( item.PROVINCE != null ) 			iCont.MailingCity 				= item.PROVINCE;
                    if( item.STREET_NAME != null ) 			iCont.MailingStreet 			= item.STREET_NAME;
                    if( item.ACT_STATUS != null ) 			iCont.Act_Status__c 			= item.ACT_STATUS;
                    if( item.VIP != null ) 					iCont.Vip__c 					= Boolean.valueof(item.VIP);
                    if( item.CEN_CODE != null ) 			iCont.Cen_Code__c 				= item.CEN_CODE;
                    if( item.ACTIVE_PHONE != null ) 		iCont.Active_Phone__c 			= item.ACTIVE_PHONE;
                    if( item.EMAIL != null ) 				iCont.Email 					= item.EMAIL;
                    if( item.USER_SUBNAME != null ) 		iCont.User_Subname__c 			= item.USER_SUBNAME;
                    if( item.SUB_TYPE != null ) 			iCont.Sub_Type__c 				= item.SUB_TYPE;
                    if( item.IMSI != null ) 				iCont.IMSI_Number__c 			= item.IMSI;
                    if( item.CONTRACT_NO != null ) 			iCont.Contract_No__c 			= item.CONTRACT_NO;
                    if( item.CONTRACT_DATE != null ) 		iCont.Contract_Date__c 			= date.parse(item.CONTRACT_DATE);
                    if( item.STA_DATETIME != null ) 		iCont.Start_Date__c 			= date.parse(item.STA_DATETIME);
                    if( item.USER_FULLNAME != null ) 		iCont.User_Name__c 				= item.USER_FULLNAME;
                    if( item.CEN_CODE_DEV != null ) 		iCont.Cen_Code_Dev__c 			= item.CEN_CODE_DEV;
                    if( item.DEP_PROVINCE != null ) 		iCont.OtherCity 				= item.DEP_PROVINCE;
                    if( item.DEP_STREET_NAME != null ) 		iCont.OtherStreet 				= item.DEP_STREET_NAME;
                    if( item.NAME != null ) 				iCont.Lastname 					= item.NAME;
                    if( item.STOCK_ISDN_CEN_CODE != null ) 	iCont.Stock_Isdn_Cen_Code__c 	= item.STOCK_ISDN_CEN_CODE;
                    if( item.EMPLOYEE != null ) 			iCont.Employee__c 				= item.EMPLOYEE;
                    if( item.SUB_CODE != null ) 			iCont.Sub_Code__c 				= item.SUB_CODE;
                    //if( item.SUB_PROM_HISTORY != null ) 	iCont.Prom_History__c 			= item.SUB_PROM_HISTORY;
                    //if( item.VERIFY != null ) 			iCont.Verify__c 				= item.VERIFY;
                    //if( item.PROFILE_TYPE != null ) 		iCont.Profile_Type__c 			= item.PROFILE_TYPE;
                    //if( item.EMAIL_TBC != null ) 			iCont.Email_Tbc__c 				= item.EMAIL_TBC;
                    //if( item.SUB_TRUST != null ) 			iCont.Sub_Trust__c 				= item.SUB_TRUST;
                    //if( item.COR_NATION != null )			iCont.Cor_Nation__c 			= Boolean.valueof(item.COR_NATION);
                    //if( item.RECORD_TYPE != null ) 		iCont.recordTypeName			= item.RECORD_TYPE;
                    lstUpsert.add(iCont);
                }
            }
            
            if(lstUpsert.size() > 0){
                Integer count = 0;
                Schema.SObjectField ftoken = Contact.Fields.Id;
                Database.UpsertResult[] srList = Database.upsert(lstUpsert, ftoken, false);

                for(Contact iCont :lstUpsert){
                    valueSet result = new valueSet();
                    result.Contact_Id_DB = iCont.Sub_Id__c;
                    result.Contact_Id_SF = iCont.Id;
                    for (Database.Error error : srList[count].getErrors()) {
                        result.error_Mess = error.getMessage();
                        System.debug('Error status code: ' + error.getStatusCode());
                        System.debug('Error message: ' + error.getMessage());
                        System.debug('Error fields: ' + String.join(error.getFields(), ', '));
                    }
                    body.add(result);
                    count += 1;
                }
                
                if(body.size() > 0){
                    wrapperResponseBody resultResponseBody = new wrapperResponseBody();
                    resultResponseBody.Status = 'Success';
                    resultResponseBody.lstInsert = body;
                    
                    //String result = 'Create Case successfully, Case ID: ' + newTicket.Id;
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(JSON.serialize(resultResponseBody));
                }
            }
        } catch (Exception ex) {
            valueSet result = new valueSet();
            
            // Rollback transaction in case of error
            Database.rollback(sp);
            
            wrapperResponseBody resultResponseBody = new wrapperResponseBody();
            resultResponseBody.Status = 'fail: ' + ex.getMessage();
            
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(resultResponseBody));
            
            Log_Utils.createLogApiInbound('create-contact', req, '/api/createContact/', res);
            System.debug('Exception Message: ' + ex.getMessage());
        }
    }
    
    public class valueSet {
        public String Contact_Id_DB;
        public String Contact_Id_SF;
        public String error_Mess;
    }
    
    public class wrapperResponseBody {
        public list<valueSet> lstInsert;
        public String Status;
    }
    
    public class dataWrapper {
        public String ACCOUNT_ID { get; set; }
        public String CONTACT_ID { get; set; }
        public String SERVICE_CATEGORY_ID { get; set; }
        public String ISDN { get; set; }
        public String SUB_ID { get; set; }
        public String STATUS { get; set; }
        public String PAY_METHOD { get; set; }
        public String PROVINCE { get; set; }
        public String STREET_NAME { get; set; }
        public String ACT_STATUS { get; set; }
        public String VIP { get; set; }
        public String CEN_CODE { get; set; }
        public String ACTIVE_PHONE { get; set; }
        public String EMAIL { get; set; }
        public String USER_SUBNAME { get; set; }
        public String SUB_TYPE { get; set; }
        public String IMSI { get; set; }
        public String CONTRACT_NO { get; set; }
        public String CONTRACT_DATE { get; set; }
        public String STA_DATETIME { get; set; }
        public String USER_FULLNAME { get; set; }
        public String CEN_CODE_DEV { get; set; }
        public String DEP_PROVINCE { get; set; }
        public String DEP_STREET_NAME { get; set; }
        public String NAME { get; set; }
        public String STOCK_ISDN_CEN_CODE { get; set; }
        public String EMPLOYEE { get; set; }
        public String SUB_CODE { get; set; }
        //public String SUB_PROM_HISTORY { get; set; }
        //public String VERIFY { get; set; }
        //public String PROFILE_TYPE { get; set; }
        //public String EMAIL_TBC { get; set; }
        //public String SUB_TRUST { get; set; }
        //public String COR_NATION { get; set; }
        //public String RECORD_TYPE { get; set; }
    }


}