/**
* @description       : The Class for API Create Account from Omni DB
* @author            : ndmanh - GMS
* @last modified on  : 2024.06.03
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@RestResource(urlMapping='/createAccount/*')
global with sharing class R1_CreateAccount {
    @HttpPost
    global static void doPost(){
        Savepoint sp = Database.setSavepoint();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String resBody = req.requestBody.toString();
        
        List<Account> lstUpsert = new List<Account>();
        List<valueSet> body = new List<valueSet>();
        List<dataWrapper> wrapperList = new List<dataWrapper>();
        system.debug(resBody);
        if(resBody.length() > 0){
            wrapperList = (List<dataWrapper>) JSON.deserialize(resBody, List<dataWrapper>.class);
            // ibody = (List<dataWrapper>) System.JSON.deserialize(resBody, List<dataWrapper>.class);
        }
        Map<String, String> mapError = new Map<String, String>();
        try{
            if(wrapperList.size() > 0){
                for(dataWrapper item: wrapperList){
                    try{
                        Account iAcc = new Account();
                        if(item.ACC_KEY != null) iAcc.Acc_Key__c = item.ACC_KEY;
                        if(item.ACCOUNT_TYPE != null) iAcc.Account_Type__c = item.ACCOUNT_TYPE;
                        if(item.NAME != null) iAcc.Name = item.NAME;
                        if(item.CUST_ID != null) iAcc.Cust_Id__c = item.CUST_ID;
                        if(item.BUS_TYPE != null) iAcc.Bus_Type__c = item.BUS_TYPE;
                        if(item.PAY_FULL_ADDRESS != null) iAcc.Payment_Address__c = item.PAY_FULL_ADDRESS;
                        if(item.INV_PROVINCE != null) iAcc.BillingCity = item.INV_PROVINCE;
                        if(item.INV_STREET_NAME != null) iAcc.BillingStreet = item.INV_STREET_NAME;
                        if(item.ID_NO != null) iAcc.Id_No__c = item.ID_NO;
                        if(item.CUST_TYPE != null) iAcc.Cust_Type__c = item.CUST_TYPE;
                        if(item.BUSINESS_GROUP != null) iAcc.Business__c = item.BUSINESS_GROUP;
                        if(item.REG_BUSINESS != null) iAcc.Job__c = item.REG_BUSINESS;
                        if(item.SEX != null) iAcc.Sex__c = item.SEX;
                        if(item.BIRTH_DATE != null) iAcc.Birth_Date__c = date.parse(item.BIRTH_DATE.split(' ')[0]);
                        if(item.NATIONALITY != null) iAcc.Nationality__c = item.NATIONALITY;
                        if(item.SUB_INTERESTED != null) iAcc.Interest__c = item.SUB_INTERESTED;
                        if(item.LANGUAGE != null) iAcc.Language__c = item.LANGUAGE;
                        if(item.EMAIL != null) iAcc.Email__c = item.EMAIL;
                        if(item.TEL_FAX != null) iAcc.Phone = item.TEL_FAX;
                        if(item.FOUNDED_DATE != null) iAcc.Founded_Date__c = date.parse(item.FOUNDED_DATE);
                        if(item.FAX != null) iAcc.Fax = item.FAX;
                        if(item.BUS_PERMIT_NO != null) iAcc.Bus_Permit_No__c = item.BUS_PERMIT_NO;
                        if(item.TIN != null) iAcc.Tin__c = item.TIN;
                        if(item.CONTACT_NAME != null) iAcc.Contact_Sub_Id__c = item.CONTACT_NAME;
                        if(item.AUTHOR_SUBNAME != null) iAcc.Author_Sub_Id__c = item.AUTHOR_SUBNAME;
                        if(item.VIP != null) iAcc.Vip__c = Boolean.ValueOf(item.VIP);
                        if(item.ACCOUNT_ID != null) iAcc.Id = item.ACCOUNT_ID;
                        
                        //iAcc.Address = item.ADDRESS;
                        //iAcc.BillingAddress = item.INV_ADDRESS;
                        //iAcc.Res_Address__c = item.POP_ISSUE_PLACE;
                        //if(item.POP_ISSUE_PLACE != null) iAcc.Pop_Issue_Place__c = item.POP_ISSUE_PLACE;
                        //if(item.ID_ISSUE_DATE != null) iAcc.Id_Issue_Date__c = date.parse(item.ID_ISSUE_DATE);
                        //if(item.ID_ISSUE_PLACE != null) iAcc.Id_Issue_Place__c = item.ID_ISSUE_PLACE;
                        //if(item.POP_NO != null) iAcc.Pop_No__c = item.POP_NO;
                        //if(item.POP_ISSUE_DATE != null) iAcc.Pop_Issue_Date__c = date.parse(item.POP_ISSUE_DATE);
                        //if(item.RES_PROVINCE != null) iAcc.ShippingCity = item.RES_PROVINCE;
                        //if(item.RES_STREET_NAME != null) iAcc.ShippingStreet = item.RES_STREET_NAME;
                        
                        lstUpsert.add(iAcc);
                    } catch (Exception ex) {
                        mapError.put(item.ACC_KEY, ex.getMessage());
                    }
                }
            }
            // trả về các record thành công
            if(lstUpsert.size() > 0){
                Integer count = 0;
                Schema.SObjectField ftoken = Account.Fields.Id; //Acc_Key__c;
                Database.UpsertResult[] srList = Database.upsert(lstUpsert, ftoken, false);

                for(Account iAcc :lstUpsert){
                    valueSet result = new valueSet();
                    result.Account_Id_DB = iAcc.Acc_Key__c;
                    result.Account_Id_SF = iAcc.Id;
                    for (Database.Error error : srList[count].getErrors()) {
                        result.error_Mess = error.getMessage();
                        System.debug('Error status code: ' + error.getStatusCode());
                        System.debug('Error message: ' + error.getMessage());
                        System.debug('Error fields: ' + String.join(error.getFields(), ', '));
                    }
                    body.add(result);
                    count += 1;
                }
            }
        } catch (Exception ex) {
            valueSet result = new valueSet();
            
            // Rollback transaction in case of error
            //Database.rollback(sp);
            
            wrapperResponseBody resultResponseBody = new wrapperResponseBody();
            resultResponseBody.Status = 'fail: ' + ex.getMessage();
            
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(resultResponseBody));
            
            Log_Utils.createLogApiInbound('create-account', req, '/api/createAccount/', res);
            System.debug('Exception Message: ' + ex.getMessage());
        }
        
        // trả về các record lỗi
        if(mapError != null){
            for(String iError: mapError.keySet()){
                valueSet result = new valueSet();
                result.Account_Id_DB = iError;
                result.error_Mess = mapError.get(iError);
                body.add(result);
            }
        }
        
        // gán body
        if(body.size() > 0){
            wrapperResponseBody resultResponseBody = new wrapperResponseBody();
            resultResponseBody.Status = 'Success';
            resultResponseBody.lstInsert = body;
            
            //String result = 'Create Case successfully, Case ID: ' + newTicket.Id;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(resultResponseBody));
        }
        
    }
    
    public class valueSet {
        public String Account_Id_DB;
        public String Account_Id_SF;
        public String error_Mess;
    }
    
    public class wrapperResponseBody {
        public list<valueSet> lstInsert;
        public String Status;
    }
    
    public class dataWrapper {
        public String ACC_KEY { get; set; }
        public String ACCOUNT_TYPE { get; set; }
        public String NAME { get; set; }
        public String CUST_ID { get; set; }
        public String BUS_TYPE { get; set; }
        public String PAY_FULL_ADDRESS { get; set; }
        public String INV_PROVINCE { get; set; }
        public String INV_STREET_NAME { get; set; }
        public String ID_NO { get; set; }
        //public String POP_ISSUE_PLACE { get; set; }
        public String CUST_TYPE { get; set; }
        public String BUSINESS_GROUP { get; set; }
        public String REG_BUSINESS { get; set; }
        public String SEX { get; set; }
        public String BIRTH_DATE { get; set; }
        public String NATIONALITY { get; set; }
        //public String ID_ISSUE_DATE { get; set; }
        //public String ID_ISSUE_PLACE { get; set; }
        public String SUB_INTERESTED { get; set; }
        public String LANGUAGE { get; set; }
        public String EMAIL { get; set; }
        public String TEL_FAX { get; set; }
        //public String RES_PROVINCE { get; set; }
        //public String RES_STREET_NAME { get; set; }
        public String FOUNDED_DATE { get; set; }
        public String FAX { get; set; }
        public String BUS_PERMIT_NO { get; set; }
        public String TIN { get; set; }
        public String CONTACT_NAME { get; set; }
        public String AUTHOR_SUBNAME { get; set; }
        //public String POP_NO { get; set; }
        //public String POP_ISSUE_DATE { get; set; }
        public String VIP { get; set; }
		public String ACCOUNT_ID { get; set; }
    }


}