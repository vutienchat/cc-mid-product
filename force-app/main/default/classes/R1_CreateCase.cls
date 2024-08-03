/**
* @description       : The Class for API Create Case from Omni DB
* @author            : ndmanh - GMS
* @last modified on  : 2024.06.07
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@RestResource(urlMapping='/createCase/*')
global with sharing class R1_CreateCase {
    @HttpPost
    global static void doPost(){
        Savepoint sp = Database.setSavepoint();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String resBody = req.requestBody.toString();
        
        List<Case> lstUpsert = new List<Case>();
        List<valueSet> body = new List<valueSet>();
        List<dataWrapper> wrapperList = new List<dataWrapper>();
        system.debug(resBody);
        
		id recordtypePAKHId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PAKH').getRecordTypeId();        
        if(resBody.length() > 0){
            wrapperList = (List<dataWrapper>) JSON.deserialize(resBody, List<dataWrapper>.class);
            // ibody = (List<dataWrapper>) System.JSON.deserialize(resBody, List<dataWrapper>.class);
        }
        
        //try{
        if(wrapperList.size() > 0){
            for(dataWrapper item: wrapperList){
                Case iCase = new Case();
                // Nếu đẩy vào phone, cần tìm contact id dựa trên phone và gắn vào contactId của case => if( item.PHONE != null ) iCase.ContactPhone = item.PHONE;
                
                //if( item.ADDRESS != null ) iCase.Address__c = item.ADDRESS;
                if( item.CASE_ID != null ) iCase.Id = item.CASE_ID;
                if( item.FBTEMP_NOT_UPDATED != null ) iCase.fbtemp_Not_Updated__c = Boolean.valueof(item.FBTEMP_NOT_UPDATED);
                if( item.FBTEMP_IS_USING_NORMALLY_AT_THIS_TIME != null ) iCase.fbtemp_Is_Using_Normally_at_this_time__c = Boolean.valueof(item.FBTEMP_IS_USING_NORMALLY_AT_THIS_TIME);
                if( item.URGENT != null ) iCase.Urgent__c = Boolean.valueof(item.URGENT);
                if( item.CALL_BACK_REQUIRE != null ) iCase.Call_Request__c = Boolean.valueof(item.CALL_BACK_REQUIRE);
                if( item.TEMPORARY_CLOSE != null ) iCase.Close_Request__c = Boolean.valueof(item.TEMPORARY_CLOSE);
                //if( item.FBTEMP_CHECK_CONNECTION_SIM_IP_PING != null ) iCase.fbtemp_Check_Connection_SIM_IP_Ping = item.FBTEMP_CHECK_CONNECTION_SIM_IP_PING;
                if( item.FBTEMP_ERROR_DATE != null ) iCase.fbtemp_Error_Date__c = date.parse(item.FBTEMP_ERROR_DATE);
                if( item.FBTEMP_CHANGE_DATE != null ) iCase.fbtemp_Change_Date__c = date.parse(item.FBTEMP_CHANGE_DATE);
                if( item.FBTEMP_DATE_SWITCH_PRE_PAID != null ) iCase.fbtemp_Date_Switch_Pre_Paid__c = date.parse(item.FBTEMP_DATE_SWITCH_PRE_PAID);
                if( item.FEEDBACK_DATE != null ) iCase.Respond_Date__c = date.parse(item.FEEDBACK_DATE);
                if( item.FBTEMP_DATE_LOST_ACCOUNT != null ) iCase.fbtemp_Date_Lost_Account__c = date.parse(item.FBTEMP_DATE_LOST_ACCOUNT);
                if( item.FBTEMP_RECHARGE_DATE != null ) iCase.fbtemp_Recharge_Date__c = date.parse(item.FBTEMP_RECHARGE_DATE);
                if( item.FBTEMP_DATETIME != null ) iCase.fbtemp_DateTime__c = date.parse(item.FBTEMP_DATETIME);
                if( item.FBTEMP_TIME_BEGIN != null ) iCase.fbtemp_Time_Begin__c = date.parse(item.FBTEMP_TIME_BEGIN);
                //if( item.END_DATE != null ) iCase.End_Date__c = item.END_DATE;
                if( item.FBTEMP_EMAIL_ADDRESS != null ) iCase.fbtemp_Email_Address__c = item.FBTEMP_EMAIL_ADDRESS;
                if( item.COMP_CONTENT != null ) iCase.Description = item.COMP_CONTENT;
                if( item.PRE_RESULT != null ) iCase.Preprocess_Content__c = item.PRE_RESULT;
                if( item.ERROR_CAUSE_DETAIL != null ) iCase.Error_Cause_Detail__c = item.ERROR_CAUSE_DETAIL;
                if( item.RESULT_CONTENT != null ) iCase.Preprocess_Result__c = item.RESULT_CONTENT;
                if( item.ACCOUNT_ID != null ) iCase.AccountId = item.ACCOUNT_ID;
                if( item.END_USER != null ) iCase.Request_Owner__c = item.END_USER;
                if( item.ACCEPT_SOURCE_ID != null ) iCase.Request_Source__c = item.ACCEPT_SOURCE_ID;
                if( item.ACCEPT_USER != null ) iCase.Accept_Agent__c = item.ACCEPT_USER;
                if( item.FBTEMP_ACTIVATION_NUMBER != null ) iCase.fbtemp_Activation_Number__c = item.FBTEMP_ACTIVATION_NUMBER;
                //if( item.COMPLAIN_LEVEL != null ) iCase.Complain_Level__c = item.COMPLAIN_LEVEL;
                if( item.DETAIL_ERROR_ID != null ) iCase.Detail_Error__c = item.DETAIL_ERROR_ID;
                if( item.FBTEMP_PERMANENT_OR_TEMPORARY != null ) iCase.fbtemp_Permanent_or_temporary__c = item.FBTEMP_PERMANENT_OR_TEMPORARY;
                if( item.ACCEPT_TYPE_ID != null ) iCase.Request_Form__c = item.ACCEPT_TYPE_ID;
                if( item.FBTEMP_COMPLAIN_TYPE != null ) iCase.fbtemp_Complain_Type__c = item.FBTEMP_COMPLAIN_TYPE;
                if( item.FBTEMP_CANCEL_REQUEST_TYPE != null ) iCase.fbtemp_Cancel_Request_Type__c = item.FBTEMP_CANCEL_REQUEST_TYPE;
                if( item.FBTEMP_USING_SIM != null ) iCase.fbtemp_Using_SIM__c = item.FBTEMP_USING_SIM;
                if( item.FBTEMP_BLOCKEDBY_SMSC != null ) iCase.fbtemp_BlockedBy_SMSC__c = item.FBTEMP_BLOCKEDBY_SMSC;
                if( item.STATUS != null ) iCase.Status = item.STATUS;
                if( item.CEN_CODE != null ) iCase.Implementation_Unit__c = item.CEN_CODE;
                if( item.FEEDBACK_STATUS != null ) iCase.Feedback_Status__c = item.FEEDBACK_STATUS;
                if( recordtypePAKHId != null ) iCase.RecordTypeId = recordtypePAKHId;
                if( item.NOTE != null ) iCase.Comments = item.NOTE;
                if( item.FBTEMP_DENOMINATION != null ) iCase.fbtemp_denomination__c = item.FBTEMP_DENOMINATION;
                if( item.FBTEMP_AMOUNT != null ) iCase.fbtemp_Amount__c = item.FBTEMP_AMOUNT;
                if( item.FBTEMP_ACCOUNT_BALANCE != null ) iCase.fbtemp_Account_Balance__c = item.FBTEMP_ACCOUNT_BALANCE;
                if( item.FBTEMP_ACC_AFTER_LOST != null ) iCase.fbtemp_Acc_After_Lost__c = item.FBTEMP_ACC_AFTER_LOST;
                if( item.FBTEMP_EVENT != null ) iCase.fbtemp_event__c = item.FBTEMP_EVENT;
                if( item.FBTEMP_PACKAGE != null ) iCase.fbtemp_Package__c = item.FBTEMP_PACKAGE;
                if( item.FBTEMP_BALANCE_AMOUNT != null ) iCase.fbtemp_Balance_Amount__c = item.FBTEMP_BALANCE_AMOUNT;
                if( item.FBTEMP_DOCUMENTARY != null ) iCase.fbtemp_Documentary__c = item.FBTEMP_DOCUMENTARY;
                if( item.FBTEMP_PHONE_TO != null ) iCase.fbtemp_Phone_To__c = item.FBTEMP_PHONE_TO;
                //if( item.RESPOND_TYPE != null ) iCase.Respond_Type__c = item.RESPOND_TYPE;
                if( item.COMP_FEEDBACK_TYPE_ID != null ) iCase.fbtemp_Respond_Type__c = item.COMP_FEEDBACK_TYPE_ID;
                if( item.REFERENCE_ID != null ) iCase.ReferenceId__c = item.REFERENCE_ID;
                if( item.FBTEMP_TAX_CODE != null ) iCase.fbtemp_Tax_Code__c = item.FBTEMP_TAX_CODE;
                if( item.FBTEMP_RECEIVE_FROM != null ) iCase.fbtemp_Receive_From__c = item.FBTEMP_RECEIVE_FROM;
                if( item.FBTEMP_RECHARGE_METHOD != null ) iCase.fbtemp_Recharge_Method__c = item.FBTEMP_RECHARGE_METHOD;
                if( item.FBTEMP_SERIAL != null ) iCase.fbtemp_Serial__c = item.FBTEMP_SERIAL;
                if( item.FBTEMP_IDENTITYCARDNUMBER != null ) iCase.fbtemp_IdentityCardNumber__c = item.FBTEMP_IDENTITYCARDNUMBER;
                if( item.FBTEMP_HARASSED_PHONE != null ) iCase.fbtemp_Harassed_Phone__c = item.FBTEMP_HARASSED_PHONE;
                if( item.FBTEMP_MISSING_AMOUNT != null ) iCase.fbtemp_Missing_Amount__c = item.FBTEMP_MISSING_AMOUNT;
                if( item.FBTEMP_RECEIVED_AMOUNT != null ) iCase.fbtemp_Received_Amount__c = item.FBTEMP_RECEIVED_AMOUNT;
                if( item.FBTEMP_CONTACT_PHONE != null ) iCase.fbtemp_Contact_Phone__c = item.FBTEMP_CONTACT_PHONE;
                if( item.FBTEMP_HARASSED_CONTACT != null ) iCase.fbtemp_Harassed_Contact__c = item.FBTEMP_HARASSED_CONTACT;
                if( item.COMPLAIN_ID != null ) iCase.COMPLAIN_ID__c = item.COMPLAIN_ID;
                if( item.FBTEMP_RECEIVE_FROM_CALL_TO != null ) iCase.fbtemp_Receive_From_Call_To__c = item.FBTEMP_RECEIVE_FROM_CALL_TO;
                if( item.FBTEMP_AREA_WHEN_INSPECT != null ) iCase.fbtemp_Area_When_Inspect__c = item.FBTEMP_AREA_WHEN_INSPECT;
                if( item.FBTEMP_NETWORK_SUBSCRIBER_USING != null ) iCase.fbtemp_Network_Subscriber_Using__c = item.FBTEMP_NETWORK_SUBSCRIBER_USING;
                if( item.FBTEMP_CHOOSE_CORRECT_SIM_NETWORK_ACCES != null ) iCase.fbtemp_Choose_correct_SIM_network_acces__c = item.FBTEMP_CHOOSE_CORRECT_SIM_NETWORK_ACCES;
                //if( item.FBTEMP_STORE != null ) iCase.fbtemp_Store__c = item.FBTEMP_STORE;
                if( item.FBTEMP_LEFT_STORAGE != null ) iCase.fbtemp_Left_Storage__c = item.FBTEMP_LEFT_STORAGE;
                if( item.FBTEMP_SERVICE != null ) iCase.fbtemp_Service__c = item.FBTEMP_SERVICE;
                if( item.FBTEMP_CURRENT_PLAN != null ) iCase.fbtemp_Current_Plan__c = item.FBTEMP_CURRENT_PLAN;
                if( item.FBTEMP_DATA_PACKAGE_USING != null ) iCase.fbtemp_Data_Package_Using__c = item.FBTEMP_DATA_PACKAGE_USING;
                if( item.FBTEMP_ERRORS_AREA != null ) iCase.fbtemp_Errors_Area__c = item.FBTEMP_ERRORS_AREA;
                if( item.FBTEMP_CHECK_DEVICE_AND_SIM_ERRORS != null ) iCase.fbtemp_Check_Device_and_SIM_Errors__c = item.FBTEMP_CHECK_DEVICE_AND_SIM_ERRORS;
                if( item.FBTEMP_DISPLAY_SIGNAL != null ) iCase.fbtemp_Display_Signal__c = item.FBTEMP_DISPLAY_SIGNAL;
                if( item.FBTEMP_REASON != null ) iCase.fbtemp_Reason__c = item.FBTEMP_REASON;
                if( item.FBTEMP_USED_PHONE != null ) iCase.fbtemp_Used_Phone__c = item.FBTEMP_USED_PHONE;
                if( item.FBTEMP_TIME_OR_PERIOD_TIME != null ) iCase.fbtemp_Time_or_Period_Time__c = item.FBTEMP_TIME_OR_PERIOD_TIME;
                if( item.FBTEMP_CONTENT != null ) iCase.fbtemp_Content__c = item.FBTEMP_CONTENT;
                if( item.FBTEMP_NOTI_DISPLAY_WHEN_UNCONTACTABLE != null ) iCase.fbtemp_Noti_Display_When_Uncontactable__c = item.FBTEMP_NOTI_DISPLAY_WHEN_UNCONTACTABLE;
                if( item.FBTEMP_OTHER_INFORMATION != null ) iCase.fbtemp_Other_information__c = item.FBTEMP_OTHER_INFORMATION;
                if( item.FBTEMP_ERROR_TIME != null ) iCase.fbtemp_Error_Time__c = item.FBTEMP_ERROR_TIME;
                if( item.TITLE != null ) iCase.Subject = item.TITLE;
                if( item.FBTEMP_PROMOTION_PROGRAM != null ) iCase.fbtemp_Promotion_Program__c = item.FBTEMP_PROMOTION_PROGRAM;
                if( item.FBTEMP_ERROR_STATUS != null ) iCase.fbtemp_Error_Status__c = item.FBTEMP_ERROR_STATUS;
                if( item.FBTEMP_CURRENT_STATUS_QUO != null ) iCase.fbtemp_Current_Status_Quo__c = item.FBTEMP_CURRENT_STATUS_QUO;
                if( item.FBTEMP_MESSAGE_SHOWN_WHEN_UNCONTACTABLE != null ) iCase.fbtemp_Message_Shown_When_Uncontactable__c = item.FBTEMP_MESSAGE_SHOWN_WHEN_UNCONTACTABLE;
                if( item.FBTEMP_CUSTOMER_REQUEST != null ) iCase.fbtemp_Customer_Request__c = item.FBTEMP_CUSTOMER_REQUEST;
                if( item.FBTEMP_AREA_USING != null ) iCase.fbtemp_Area_Using__c = item.FBTEMP_AREA_USING;
                if( item.FBTEMP_STORE_ADDRESS != null ) iCase.fbtemp_Store_Address__c = item.FBTEMP_STORE_ADDRESS;
                if( item.FBTEMP_ADDRESS != null ) iCase.fbtemp_Address__c = item.FBTEMP_ADDRESS;
                if( item.FBTEMP_SHIPPING_ADDRESS != null ) iCase.fbtemp_Shipping_Address__c = item.FBTEMP_SHIPPING_ADDRESS;
                if( item.FBTEMP_BILLING_ADDRESS != null ) iCase.fbtemp_Billing_Address__c = item.FBTEMP_BILLING_ADDRESS;
                if( item.FBTEMP_NETWORK_INACCESSIBLE_ADDRESS != null ) iCase.fbtemp_Network_Inaccessible_Address__c = item.FBTEMP_NETWORK_INACCESSIBLE_ADDRESS;
                if( item.FBTEMP_INACCESSIBLE_WEB_SERVICES != null ) iCase.fbtemp_Inaccessible_Web_Services__c = item.FBTEMP_INACCESSIBLE_WEB_SERVICES;
                //if( item.FBTEMP_RESULT_CHECK_CONNECTION_BY_PING != null ) iCase.fbtemp_Result_Check_Connection_By_Ping = item.FBTEMP_RESULT_CHECK_CONNECTION_BY_PING;
                //if( item.FBTEMP_BUSINESS_CONTACT_POINT != null ) iCase.fbtemp_Business_Contact_Point = item.FBTEMP_BUSINESS_CONTACT_POINT;
                //if( item.FBTEMP_AMOUNT_SIM_DISCONNECTED != null ) iCase.fbtemp_Amount_SIM_Disconnected = item.FBTEMP_AMOUNT_SIM_DISCONNECTED;
                //if( item.FBTEMP_ERROR_PHONE != null ) iCase.fbtemp_Error_Phone = item.FBTEMP_ERROR_PHONE;
                if( item.FBTEMP_ERROR_MESSAGE != null ) iCase.fbtemp_Error_Message__c = item.FBTEMP_ERROR_MESSAGE;
                if( item.FBTEMP_DEVICE_TYPE != null ) iCase.fbtemp_Device_Type__c = item.FBTEMP_DEVICE_TYPE;
                if( item.FBTEMP_MODEL != null ) iCase.fbtemp_model__c = item.FBTEMP_MODEL;
                if( item.FBTEMP_REQUEST != null ) iCase.fbtemp_Request__c = item.FBTEMP_REQUEST;
                if( item.FBTEMP_NEAR != null ) iCase.fbtemp_Near__c = item.FBTEMP_NEAR;
                if( item.FBTEMP_TYPE_OF_HARASSMENT != null ) iCase.fbtemp_Type_of_Harassment__c = item.FBTEMP_TYPE_OF_HARASSMENT;
                if( item.FBTEMP_SIM_TYPE_USING != null ) iCase.fbtemp_SIM_Type_Using__c = item.FBTEMP_SIM_TYPE_USING;
                if( item.FBTEMP_TIME != null ) iCase.fbtemp_Time__c = item.FBTEMP_TIME;
                if( item.FBTEMP_REGISTER_NUMBER_EZ != null ) iCase.fbtemp_Register_Number_EZ__c = item.FBTEMP_REGISTER_NUMBER_EZ;
                if( item.FBTEMP_AMOUNTEZNUMBER_NOT_RECEIVE_KK != null ) iCase.fbtemp_AmountEZNumber_Not_Receive_KK__c = item.FBTEMP_AMOUNTEZNUMBER_NOT_RECEIVE_KK;
                if( item.FBTEMP_RECHARGED_AMOUNT != null ) iCase.fbtemp_Recharged_Amount__c = item.FBTEMP_RECHARGED_AMOUNT;
                if( item.FBTEMP_STAFF != null ) iCase.fbtemp_Staff__c = item.FBTEMP_STAFF;
                if( item.FBTEMP_FREQUENCY_OF_HARASSMENT != null ) iCase.fbtemp_Frequency_of_Harassment__c = item.FBTEMP_FREQUENCY_OF_HARASSMENT;
                if( item.COMPLAIN_TYPE != null ) iCase.Type = item.COMPLAIN_TYPE;
                if( item.GROUP_ID != null ) iCase.Request_Group__c = item.GROUP_ID;
                if( item.COMP_TYPE_ID != null ) iCase.Request_Type__c = item.COMP_TYPE_ID;
                System.debug('Type: ' + iCase.Type + '-' + iCase.Request_Group__c + '-' + iCase.Request_Type__c);
                lstUpsert.add(iCase);
            }
        }
        
        if(lstUpsert.size() > 0){
            Integer count = 0;
            Schema.SObjectField ftoken = Case.Fields.Id;
            Database.UpsertResult[] srList = Database.upsert(lstUpsert, ftoken, false);
            system.debug(lstUpsert);
            system.debug(lstUpsert[0].Id);
            for(Case iCase :lstUpsert){
                system.debug('iCase.Id: ' + iCase.Id);
                valueSet result = new valueSet();
                result.Case_Id_DB = iCase.COMPLAIN_ID__c;
                result.Case_Id_SF = iCase.Id;
                
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
        /*} catch (Exception ex) {
valueSet result = new valueSet();

// Rollback transaction in case of error
Database.rollback(sp);

wrapperResponseBody resultResponseBody = new wrapperResponseBody();
resultResponseBody.Status = 'fail: ' + ex.getMessage();

res.statusCode = 500;
res.responseBody = Blob.valueOf(JSON.serialize(resultResponseBody));

Log_Utils.createLogApiInbound('create-case', req, '/api/createCase/', res);
System.debug('Exception Message: ' + ex.getMessage());
}*/
    }
    
    public class valueSet {
        public String Case_Id_DB;
        public String Case_Id_SF;
        public String error_Mess;
    }
    
    public class wrapperResponseBody {
        public list<valueSet> lstInsert;
        public String Status;
    }
    
    public class dataWrapper {
        public String CASE_ID { get; set; }
        Public String ADDRESS { get; set; }
        Public String FBTEMP_NOT_UPDATED { get; set; }
        Public String FBTEMP_IS_USING_NORMALLY_AT_THIS_TIME { get; set; }
        Public String URGENT { get; set; }
        Public String CALL_BACK_REQUIRE { get; set; }
        Public String TEMPORARY_CLOSE { get; set; }
        Public String FBTEMP_CHECK_CONNECTION_SIM_IP_PING { get; set; }
        Public String FBTEMP_ERROR_DATE { get; set; }
        Public String FBTEMP_CHANGE_DATE { get; set; }
        Public String FBTEMP_DATE_SWITCH_PRE_PAID { get; set; }
        Public String FEEDBACK_DATE { get; set; }
        Public String FBTEMP_DATE_LOST_ACCOUNT { get; set; }
        Public String FBTEMP_RECHARGE_DATE { get; set; }
        Public String FBTEMP_DATETIME { get; set; }
        Public String FBTEMP_TIME_BEGIN { get; set; }
        Public String END_DATE { get; set; }
        Public String EMAIL { get; set; }
        Public String FBTEMP_EMAIL_ADDRESS { get; set; }
        Public String COMP_CONTENT { get; set; }
        Public String PRE_RESULT { get; set; }
        Public String ERROR_CAUSE_DETAIL { get; set; }
        Public String RESULT_CONTENT { get; set; }
        Public String ACCOUNT_ID { get; set; }
        Public String END_USER { get; set; }
        Public String ACCEPT_SOURCE_ID { get; set; }
        Public String ACCEPT_USER { get; set; }
        Public Decimal FBTEMP_ACTIVATION_NUMBER { get; set; }
        Public Decimal COMPLAIN_LEVEL { get; set; }
        Public String PHONE { get; set; }
        Public String DETAIL_ERROR_ID { get; set; }
        Public String FBTEMP_PERMANENT_OR_TEMPORARY { get; set; }
        Public String ACCEPT_TYPE_ID { get; set; }
        Public String COMPLAIN_TYPE { get; set; }
        Public String FBTEMP_COMPLAIN_TYPE { get; set; }
        Public String COMP_TYPE_ID { get; set; }
        Public String FBTEMP_CANCEL_REQUEST_TYPE { get; set; }
        Public String FBTEMP_USING_SIM { get; set; }
        Public String FBTEMP_BLOCKEDBY_SMSC { get; set; }
        Public String STATUS { get; set; }
        Public String CEN_CODE { get; set; }
        Public String FEEDBACK_STATUS { get; set; }
        Public String RECORD_TYPE { get; set; }
        Public String NOTE { get; set; }
        Public String FBTEMP_DENOMINATION { get; set; }
        Public String FBTEMP_AMOUNT { get; set; }
        Public String FBTEMP_ACCOUNT_BALANCE { get; set; }
        Public String FBTEMP_ACC_AFTER_LOST { get; set; }
        Public String FBTEMP_EVENT { get; set; }
        Public String FBTEMP_PACKAGE { get; set; }
        Public String FBTEMP_BALANCE_AMOUNT { get; set; }
        Public String FBTEMP_DOCUMENTARY { get; set; }
        Public String FBTEMP_PHONE_TO { get; set; }
        Public String RESPOND_TYPE { get; set; }
        Public String COMP_FEEDBACK_TYPE_ID { get; set; }
        Public String REFERENCE_ID { get; set; }
        Public String FBTEMP_TAX_CODE { get; set; }
        Public String FBTEMP_RECEIVE_FROM { get; set; }
        Public String FBTEMP_RECHARGE_METHOD { get; set; }
        Public String FBTEMP_SERIAL { get; set; }
        Public String FBTEMP_IDENTITYCARDNUMBER { get; set; }
        Public String FBTEMP_HARASSED_PHONE { get; set; }
        Public String FBTEMP_MISSING_AMOUNT { get; set; }
        Public String FBTEMP_RECEIVED_AMOUNT { get; set; }
        Public String FBTEMP_CONTACT_PHONE { get; set; }
        Public String FBTEMP_HARASSED_CONTACT { get; set; }
        Public String COMPLAIN_ID { get; set; }
        Public String FBTEMP_RECEIVE_FROM_CALL_TO { get; set; }
        Public String FBTEMP_AREA_WHEN_INSPECT { get; set; }
        Public String FBTEMP_NETWORK_SUBSCRIBER_USING { get; set; }
        Public String FBTEMP_CHOOSE_CORRECT_SIM_NETWORK_ACCES { get; set; }
        Public String FBTEMP_STORE { get; set; }
        Public String FBTEMP_LEFT_STORAGE { get; set; }
        Public String FBTEMP_SERVICE { get; set; }
        Public String FBTEMP_CURRENT_PLAN { get; set; }
        Public String FBTEMP_DATA_PACKAGE_USING { get; set; }
        Public String FBTEMP_ERRORS_AREA { get; set; }
        Public String FBTEMP_CHECK_DEVICE_AND_SIM_ERRORS { get; set; }
        Public String FBTEMP_DISPLAY_SIGNAL { get; set; }
        Public String FBTEMP_REASON { get; set; }
        Public String FBTEMP_USED_PHONE { get; set; }
        Public String FBTEMP_TIME_OR_PERIOD_TIME { get; set; }
        Public String FBTEMP_CONTENT { get; set; }
        Public String FBTEMP_NOTI_DISPLAY_WHEN_UNCONTACTABLE { get; set; }
        Public String FBTEMP_OTHER_INFORMATION { get; set; }
        Public String FBTEMP_ERROR_TIME { get; set; }
        Public String TITLE { get; set; }
        Public String FBTEMP_PROMOTION_PROGRAM { get; set; }
        Public String FBTEMP_ERROR_STATUS { get; set; }
        Public String FBTEMP_CURRENT_STATUS_QUO { get; set; }
        Public String FBTEMP_MESSAGE_SHOWN_WHEN_UNCONTACTABLE { get; set; }
        Public String FBTEMP_CUSTOMER_REQUEST { get; set; }
        Public String FBTEMP_AREA_USING { get; set; }
        Public String FBTEMP_STORE_ADDRESS { get; set; }
        Public String FBTEMP_ADDRESS { get; set; }
        Public String FBTEMP_SHIPPING_ADDRESS { get; set; }
        Public String FBTEMP_BILLING_ADDRESS { get; set; }
        Public String FBTEMP_NETWORK_INACCESSIBLE_ADDRESS { get; set; }
        Public String FBTEMP_INACCESSIBLE_WEB_SERVICES { get; set; }
        Public String FBTEMP_RESULT_CHECK_CONNECTION_BY_PING { get; set; }
        Public String FBTEMP_BUSINESS_CONTACT_POINT { get; set; }
        Public String FBTEMP_AMOUNT_SIM_DISCONNECTED { get; set; }
        Public String FBTEMP_ERROR_PHONE { get; set; }
        Public String FBTEMP_ERROR_MESSAGE { get; set; }
        Public String FBTEMP_DEVICE_TYPE { get; set; }
        Public String FBTEMP_MODEL { get; set; }
        Public String FBTEMP_REQUEST { get; set; }
        Public String FBTEMP_NEAR { get; set; }
        Public String FBTEMP_TYPE_OF_HARASSMENT { get; set; }
        Public String FBTEMP_SIM_TYPE_USING { get; set; }
        Public String FBTEMP_TIME { get; set; }
        Public String FBTEMP_REGISTER_NUMBER_EZ { get; set; }
        Public String FBTEMP_AMOUNTEZNUMBER_NOT_RECEIVE_KK { get; set; }
        Public String FBTEMP_RECHARGED_AMOUNT { get; set; }
        Public String FBTEMP_STAFF { get; set; }
        Public String FBTEMP_FREQUENCY_OF_HARASSMENT { get; set; }
        Public String GROUP_ID { get; set; }
    }
}