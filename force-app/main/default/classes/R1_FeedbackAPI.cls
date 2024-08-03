/**
* @description       : The Class for insert Feedback DB
* @author            : ndmanh - GMS
* @last modified on  : 2024.05.31
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_FeedbackAPI {
    // BOUNDARY must be the same when process call API 
    private static final String BOUNDARY = String.Valueof(System.Now().getTime());
    
    @future (callout=true)
    public static void inputFB(id CaseId){
        Case iCase = [select Id, IsDeleted, MasterRecordId, CaseNumber, ContactId, AccountId, EntitlementId, SourceId, 
                      ParentId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, RecordTypeId, Status, 
                      Reason, Origin, Language, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, OwnerId, 
                      SlaStartDate, SlaExitDate, IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                      SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, Comments, LastViewedDate, LastReferencedDate, 
                      MilestoneStatus, Result_Content__c, Request_Group__c, Complain_Level__c, Request_Type__c, Feedback_Status__c, Implementation_Unit__c, 
                      Preprocess_Result__c, Check_recent_date__c, CheckLimitCreated__c, Error_Cause_Detail__c, Error_Cause__c, Rating__c, Processing_Content__c, 
                      Address__c, Id_case_omi__c, DateTime_Call_Back__c, Detail_Error__c, Lead__c, Check_online_agent__c, survey_rating__c, 
                      fbtemp_Activation_Date__c, Disturbing_Customer__c, Request_Detail__c, Contact_Phone__c, Template__c, Contact__c, fbtemp_Check_Connection_SIM_IP_Ping__c, 
                      fbtemp_Result_Check_Connection_By_Ping__c, Urgent__c, fbtemp_Date_Switch_Pre_Paid__c, fbtemp_Balance_Amount__c, Respond_Date__c, fbtemp_Respond_Type__c, 
                      fbtemp_Reason__c, fbtemp_Amount__c, Request_Time__c, Call_Request__c, Preprocess__c, ReferenceId__c, Preprocess_Content__c, Close_Request__c, Store__c, Attach_Type__c, 
                      Agent__c, fbtemp_Errors_Area__c, fbtemp_Error_Status__c, fbtemp_Service__c, fbtemp_Error_Time__c, fbtemp_Current_Plan__c, fbtemp_Left_Storage__c, fbtemp_Used_Phone__c, 
                      fbtemp_Business_Contact_Point__c, fbtemp_Check_Device_and_SIM_Errors__c, fbtemp_Choose_correct_SIM_network_acces__c, fbtemp_Other_information__c, fbtemp_Display_Signal__c, 
                      Request_Callout_Time__c, Called__c, Channel__c, bot_ticket__c, fbtemp_Recharge_Date__c, fbtemp_Serial__c, fbtemp_denomination__c, fbtemp_event__c, fbtemp_Account_Balance__c, 
                      fbtemp_Error_Message__c, fbtemp_Error_Date__c, fbtemp_Area_When_Inspect__c, fbtemp_Device_Type__c, fbtemp_model__c, fbtemp_Time_Begin__c, fbtemp_Date_Lost_Account__c, 
                      Acc_Before_Lost__c, fbtemp_Acc_After_Lost__c, fbtemp_Request__c, fbtemp_Change_Date__c, fbtemp_DateTime__c, fbtemp_Not_Updated__c, fbtemp_Recharge_Method__c, 
                      fbtemp_Documentary__c, fbtemp_Contact_Phone__c, fbtemp_Near__c, fbtemp_Time__c, fbtemp_Permanent_or_temporary__c, fbtemp_Current_Status_Quo__c, 
                      fbtemp_Is_Using_Normally_at_this_time__c, fbtemp_Using_SIM__c, fbtemp_Receive_From__c, fbtemp_Area_Using__c, fbtemp_Phone_To__c, Ward__c, District__c, City_Province__c, 
                      fbtemp_Time_or_Period_Time__c, fbtemp_Reporting_Harashed_By__c, fbtemp_Type_of_Harassment__c, fbtemp_AmountEZNumber_Not_Receive_KK__c, Call_ID__c, Street__c, 
                      fbtemp_Address__c, fbtemp_Receive_From_Call_To__c, fbtemp_Message_Shown_When_Uncontactable__c, fbtemp_Network_Subscriber_Using__c, fbtemp_Noti_Display_When_Uncontactable__c, 
                      fbtemp_Data_Package_Using__c, fbtemp_Network_Inaccessible_Address__c, fbtemp_Inaccessible_Web_Services__c, fbtemp_SIM_Type_Using__c, fbtemp_Promotion_Program__c, 
                      fbtemp_Recharged_Amount__c, Related_Store__c, fbtemp_Frequency_of_Harassment__c, fbtemp_Harassed_Phone__c, fbtemp_Billing_Address__c, fbtemp_Shipping_Address__c, 
                      fbtemp_Staff__c, fbtemp_Content__c, fbtemp_Customer_Request__c, fbtemp_Complain_Type__c, fbtemp_Store_Address__c, fbtemp_Store__c, fbtemp_IdentityCardNumber__c, 
                      fbtemp_Harassed_Contact__c, fbtemp_BlockedBy_SMSC__c, fbtemp_Package__c, Accept_Agent__c, fbtemp_Tax_Code__c, fbtemp_Cancel_Request_Type__c, fbtemp_Activation_Number__c, 
                      fbtemp_Received_Amount__c, fbtemp_Missing_Amount__c, Callout_Phone__c, Request_Source__c, Request_Form__c, COMPLAIN_ID__c, fbtemp_Amount_SIM_Disconnected__c, 
                      knowledge_suggested__c, fbtemp_Email_Address__c, fbtemp_Register_Number_EZ__c, fbtemp_Error_Phone__c
                      ,Contact.Phone,Contact.Sub_Id__c,Contact.Name,Contact.Sub_Type__c,
                      Contact.Account.Name,Contact.Cen_Code__c,Accept_Agent__r.TCQLKH_Username__c
                      ,Accept_Agent__r.DEP_ID__c,Accept_Agent__r.EMP_ID__c,
                      Request_Source__r.Accept_Source_Id__c,Contact.Contract_No__c, City_Province__r.Pay_Area_Code__c
                      FROM Case 
                      WHERE id=: CaseId];
        
        String ResponseBody ='';
        
        String fromDate = '';
        
        Blob base64Content;
        String attachmentTitle;
        //try{
        //get file Attachment
        List<ContentVersion> lstAttachment = [SELECT Id, FirstPublishLocationId,
                                              FileType,
                                              ContentSize, 
                                              Title, 
                                              ContentDocumentId,
                                              VersionData 
                                              FROM ContentVersion WHERE FirstPublishLocationId =: iCase.Id];
        
        if(lstAttachment.size() > 0){
            base64Content = lstAttachment[0].VersionData;
            attachmentTitle = lstAttachment[0].Title;
        }else{
            base64Content = null;
            attachmentTitle = 'default.txt';
        }
        
        wrapperBody body = new wrapperBody();
        
        inputFbWrapper inputFb = new inputFbWrapper();
        inputFb.caseId = iCase.Id;
        inputFb.province = iCase.City_Province__r.Pay_Area_Code__c;
        inputFb.isdn = iCase.Contact.Phone;
        inputFb.subId  = iCase.Contact.Sub_Id__c;
        inputFb.address  = iCase.fbtemp_Address__c;
        inputFb.idNo = iCase.Contact.Account.Id_No__c;
        inputFb.contactName = iCase.Contact.Name;
        inputFb.contactIsdn = iCase.Contact.Phone;
        inputFb.subType  = iCase.Contact.Sub_Type__c;
        inputFb.custName = iCase.Contact.Account.Name;
        inputFb.cenCode = iCase.Contact.Cen_Code__c;
        inputFb.cenCodeUser = iCase.Accept_Agent__r.DEP_ID__c;
        inputFb.businessType = iCase.Type;
        inputFb.memberName = iCase.Accept_Agent__r.TCQLKH_Username__c;
        inputFb.memberCode = iCase.Accept_Agent__r.EMP_ID__c;
        inputFb.requestTime = iCase.CreatedDate.format('dd/MM/yyyy HH:mm:ss');
        inputFb.requestGroup = iCase.Request_Group__c;
        if(iCase.Request_Source__r.Accept_Source_Id__c != null) inputFb.requestSource = long.valueof(iCase.Request_Source__r.Accept_Source_Id__c);
        inputFb.requestType = iCase.Request_Type__c;
        if(iCase.Request_Detail__c != null) inputFb.requestDetail = long.valueof(iCase.Request_Detail__c);
        //inputFb.callOut = iCase.Call_Request__c;
        inputFb.content = iCase.Description;
        //inputFb.urgent = iCase.Urgent__c;
        inputFb.note = iCase.Comments;
        inputFb.contractNo = iCase.Contact.Contract_No__c;
        inputFb.custNo = iCase.Contact.Account.CUST_ID__c;
        inputFb.referenceId = iCase.ReferenceId__c;
        inputFb.closeNow = iCase.Close_Request__c;
        inputFb.requestForm = Integer.valueof(iCase.Request_Form__c);
        inputFb.payAreaCode = 'HNOBTLDNGA';
        inputFb.payMethod = '01'; 
        // query template
        String template = iCase.Template__c;
        Map<String, String> mapValue = new Map<String, String>();
        String query = 'select CONTENT_ID__c, SF_FIELD__c from MBF_Mapping_API__c where TEMP_ID__c =: template AND (';
        if(iCase.Template__c == '689'){
            query += 'SF_FIELD__c 		=\'fbtemp_Recharge_Date__c\'';
            query += 'OR SF_FIELD__c 	=\'fbtemp_Not_Updated__c\'';
            query += 'OR SF_FIELD__c 	=\'fbtemp_Recharge_Method__c\'';
            query += 'OR SF_FIELD__c 	=\'fbtemp_Documentary__c\'';
            query += ')';
            mapValue.put('fbtemp_Recharge_Date__c', String.valueof(iCase.fbtemp_Recharge_Date__c));
            mapValue.put('fbtemp_Not_Updated__c', String.valueof(iCase.fbtemp_Not_Updated__c));
            mapValue.put('fbtemp_Recharge_Method__c', String.valueof(iCase.fbtemp_Recharge_Method__c));
            mapValue.put('fbtemp_Documentary__c', String.valueof(iCase.fbtemp_Documentary__c));
        }else if(iCase.Template__c == '712'){
            query += 'SF_FIELD__c		=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Contact_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Near__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Permanent_or_temporary__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Current_Status_Quo__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Is_Using_Normally_at_this_time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Using_SIM__c\'';
            query += ')';
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
            mapValue.put('fbtemp_Near__c', String.valueof(iCase.fbtemp_Near__c));
            mapValue.put('fbtemp_Time__c', String.valueof(iCase.fbtemp_Time__c));
            mapValue.put('fbtemp_Permanent_or_temporary__c', String.valueof(iCase.fbtemp_Permanent_or_temporary__c));
            mapValue.put('fbtemp_Current_Status_Quo__c', String.valueof(iCase.fbtemp_Current_Status_Quo__c));
            mapValue.put('fbtemp_Is_Using_Normally_at_this_time__c', String.valueof(iCase.fbtemp_Is_Using_Normally_at_this_time__c));
            mapValue.put('fbtemp_Using_SIM__c', String.valueof(iCase.fbtemp_Using_SIM__c));
        }else if(iCase.Template__c == '700'){
            query += 'SF_FIELD__c		=\'fbtemp_Receive_From_Call_To__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Area_Using__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Current_Status_Quo__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Contact_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Phone_To__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Area_Using__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Time_or_Period_Time__c\'';
            query += ')';
            mapValue.put('fbtemp_Receive_From_Call_To__c', String.valueof(iCase.fbtemp_Receive_From_Call_To__c));
            mapValue.put('fbtemp_Area_Using__c', String.valueof(iCase.fbtemp_Area_Using__c));
            mapValue.put('fbtemp_Current_Status_Quo__c', String.valueof(iCase.fbtemp_Current_Status_Quo__c));
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
            mapValue.put('fbtemp_Phone_To__c', String.valueof(iCase.fbtemp_Phone_To__c));
            mapValue.put('fbtemp_Area_Using__c', String.valueof(iCase.fbtemp_Area_Using__c));
            mapValue.put('fbtemp_Time__c', String.valueof(iCase.fbtemp_Time__c));
            mapValue.put('fbtemp_Time_or_Period_Time__c', String.valueof(iCase.fbtemp_Time_or_Period_Time__c));
        }else if(iCase.Template__c == '700'){
            query += 'SF_FIELD__c		=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Reporting_Harashed_By__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Type_of_Harassment__c\'';
            query += ')';
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Reporting_Harashed_By__c', String.valueof(iCase.fbtemp_Reporting_Harashed_By__c));
            mapValue.put('fbtemp_Type_of_Harassment__c', String.valueof(iCase.fbtemp_Type_of_Harassment__c));
        }else if(iCase.Template__c == '695'){
            query += 'SF_FIELD__c		=\'fbtemp_Register_Number_EZ__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_AmountEZNumber_Not_Receive_KK__c\'';
            query += ')';
            mapValue.put('fbtemp_Register_Number_EZ__c', String.valueof(iCase.fbtemp_Register_Number_EZ__c));
            mapValue.put('fbtemp_AmountEZNumber_Not_Receive_KK__c', String.valueof(iCase.fbtemp_AmountEZNumber_Not_Receive_KK__c));
        }else if(iCase.Template__c == '642'){
            query += 'SF_FIELD__c		=\'fbtemp_Time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Near__c\'';
            query += 'OR SF_FIELD__c	=\'Street__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Contact_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Time_or_Period_Time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Is_Using_Normally_at_this_time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Receive_From_Call_To__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Permanent_or_temporary__c\'';
            query += ')';
            mapValue.put('fbtemp_Time__c', String.valueof(iCase.fbtemp_Time__c));
            mapValue.put('fbtemp_Near__c', String.valueof(iCase.fbtemp_Near__c));
            mapValue.put('Street__c', String.valueof(iCase.Street__c));
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
            mapValue.put('fbtemp_Time_or_Period_Time__c', String.valueof(iCase.fbtemp_Time_or_Period_Time__c));
            mapValue.put('fbtemp_Address__c', String.valueof(iCase.fbtemp_Address__c));
            mapValue.put('fbtemp_Is_Using_Normally_at_this_time__c', String.valueof(iCase.fbtemp_Is_Using_Normally_at_this_time__c));
            mapValue.put('fbtemp_Receive_From_Call_To__c', String.valueof(iCase.fbtemp_Receive_From_Call_To__c));
            mapValue.put('fbtemp_Permanent_or_temporary__c', String.valueof(iCase.fbtemp_Permanent_or_temporary__c));
        }else if(iCase.Template__c == '646'){
            query += 'SF_FIELD__c		=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Message_Shown_When_Uncontactable__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Contact_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Is_Using_Normally_at_this_time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Network_Subscriber_Using__c\'';
            query += 'OR SF_FIELD__c	=\'Street__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Permanent_or_temporary__c\'';
            query += ')';
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Message_Shown_When_Uncontactable__c', String.valueof(iCase.fbtemp_Message_Shown_When_Uncontactable__c));
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
            mapValue.put('fbtemp_Address__c', String.valueof(iCase.fbtemp_Address__c));
            mapValue.put('fbtemp_Is_Using_Normally_at_this_time__c', String.valueof(iCase.fbtemp_Is_Using_Normally_at_this_time__c));
            mapValue.put('fbtemp_Network_Subscriber_Using__c', String.valueof(iCase.fbtemp_Network_Subscriber_Using__c));
            mapValue.put('Street__c', String.valueof(iCase.Street__c));
            mapValue.put('fbtemp_Permanent_or_temporary__c', String.valueof(iCase.fbtemp_Permanent_or_temporary__c));
        }else if(iCase.Template__c == '644'){
            query += 'SF_FIELD__c		=\'fbtemp_Noti_Display_When_Uncontactable__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Device_Type__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Data_Package_Using__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Network_Inaccessible_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Inaccessible_Web_Services__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_SIM_Type_Using__c\'';
            query += ')';
            mapValue.put('fbtemp_Noti_Display_When_Uncontactable__c', String.valueof(iCase.fbtemp_Noti_Display_When_Uncontactable__c));
            mapValue.put('fbtemp_Device_Type__c', String.valueof(iCase.fbtemp_Device_Type__c));
            mapValue.put('fbtemp_Data_Package_Using__c', String.valueof(iCase.fbtemp_Data_Package_Using__c));
            mapValue.put('fbtemp_Network_Inaccessible_Address__c', String.valueof(iCase.fbtemp_Network_Inaccessible_Address__c));
            mapValue.put('fbtemp_Inaccessible_Web_Services__c', String.valueof(iCase.fbtemp_Inaccessible_Web_Services__c));
            mapValue.put('fbtemp_SIM_Type_Using__c', String.valueof(iCase.fbtemp_SIM_Type_Using__c));
        }else if(iCase.Template__c == '3422'){
            query += 'SF_FIELD__c		=\'fbtemp_SIM_Type_Using__c\'';
            query += ')';
            mapValue.put('fbtemp_SIM_Type_Using__c', String.valueof(iCase.fbtemp_SIM_Type_Using__c));
        }else if(iCase.Template__c == '869'){
            query += 'SF_FIELD__c		=\'fbtemp_Promotion_Program__c\'';
            query += ')';
            mapValue.put('fbtemp_Promotion_Program__c', String.valueof(iCase.fbtemp_Promotion_Program__c));
        }else if(iCase.Template__c == '2682'){
            query += 'SF_FIELD__c		=\'fbtemp_Promotion_Program__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Recharged_Amount__c\'';
            query += ')';
            mapValue.put('fbtemp_Promotion_Program__c', String.valueof(iCase.fbtemp_Promotion_Program__c));
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Recharged_Amount__c', String.valueof(iCase.fbtemp_Recharged_Amount__c));
        }else if(iCase.Template__c == '2982'){
            query += 'SF_FIELD__c		=\'Related_Store__c\'';
            query += ')';
            mapValue.put('Related_Store__c', String.valueof(iCase.Related_Store__c));
        }else if(iCase.Template__c == '688'){
            query += 'SF_FIELD__c		=\'fbtemp_Type_of_Harassment__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Frequency_of_Harassment__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Harassed_Phone__c\'';
            query += ')';
            mapValue.put('fbtemp_Type_of_Harassment__c', String.valueof(iCase.fbtemp_Type_of_Harassment__c));
            mapValue.put('fbtemp_Frequency_of_Harassment__c', String.valueof(iCase.fbtemp_Frequency_of_Harassment__c));
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Harassed_Phone__c', String.valueof(iCase.fbtemp_Harassed_Phone__c));
        }else if(iCase.Template__c == '902'){
            query += 'SF_FIELD__c		=\'fbtemp_Billing_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Shipping_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Contact_Phone__c\'';
            query += ')';
            mapValue.put('fbtemp_Billing_Address__c', String.valueof(iCase.fbtemp_Billing_Address__c));
            mapValue.put('fbtemp_Shipping_Address__c', String.valueof(iCase.fbtemp_Shipping_Address__c));
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
        }else if(iCase.Template__c == '690'){
            //query += 'SF_FIELD__c		=\'fbtemp_Billing_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_event__c\'';
            query += ')';
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_event__c', String.valueof(iCase.fbtemp_event__c));
        }else if(iCase.Template__c == '671'){
            query += 'SF_FIELD__c		=\'fbtemp_Staff__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Content__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Customer_Request__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Complain_Type__c\'';
            query += ')';
            mapValue.put('fbtemp_Staff__c', String.valueof(iCase.fbtemp_Staff__c));
            mapValue.put('fbtemp_Content__c', String.valueof(iCase.fbtemp_Content__c));
            mapValue.put('fbtemp_Customer_Request__c', String.valueof(iCase.fbtemp_Customer_Request__c));
            mapValue.put('fbtemp_Complain_Type__c', String.valueof(iCase.fbtemp_Complain_Type__c));
        }else if(iCase.Template__c == '667'){
            query += 'SF_FIELD__c		=\'fbtemp_DateTime__c\'';
            query += ')';
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
        }else if(iCase.Template__c == '666'){
            query += 'SF_FIELD__c		=\'fbtemp_Store_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Store__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Contact_Phone__c\'';
            query += ')';
            mapValue.put('fbtemp_Store_Address__c', String.valueof(iCase.fbtemp_Store_Address__c));
            mapValue.put('fbtemp_Store__c', String.valueof(iCase.fbtemp_Store__c));
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
        }else if(iCase.Template__c == '681'){
            query += 'SF_FIELD__c		=\'fbtemp_Current_Status_Quo__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Customer_Request__c\'';
            query += ')';
            mapValue.put('fbtemp_Current_Status_Quo__c', String.valueof(iCase.fbtemp_Current_Status_Quo__c));
            mapValue.put('fbtemp_Customer_Request__c', String.valueof(iCase.fbtemp_Customer_Request__c));
        }else if(iCase.Template__c == '730'){
            query += 'SF_FIELD__c		=\'fbtemp_Promotion_Program__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Customer_Request__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Current_Status_Quo__c\'';
            query += ')';
            mapValue.put('fbtemp_Promotion_Program__c', String.valueof(iCase.fbtemp_Promotion_Program__c));
            mapValue.put('fbtemp_Customer_Request__c', String.valueof(iCase.fbtemp_Customer_Request__c));
            mapValue.put('fbtemp_Current_Status_Quo__c', String.valueof(iCase.fbtemp_Current_Status_Quo__c));
        }else if(iCase.Template__c == '731'){
            query += 'SF_FIELD__c		=\'fbtemp_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_IdentityCardNumber__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Type_of_Harassment__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Harassed_Contact__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += ')';
            mapValue.put('fbtemp_Address__c', String.valueof(iCase.fbtemp_Address__c));
            mapValue.put('fbtemp_IdentityCardNumber__c', String.valueof(iCase.fbtemp_IdentityCardNumber__c));
            mapValue.put('fbtemp_Type_of_Harassment__c', String.valueof(iCase.fbtemp_Type_of_Harassment__c));
            mapValue.put('fbtemp_Harassed_Contact__c', String.valueof(iCase.fbtemp_Harassed_Contact__c));
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
        }else if(iCase.Template__c == '1962'){
            query += 'SF_FIELD__c		=\'fbtemp_BlockedBy_SMSC__c\'';
            query += ')';
             mapValue.put('fbtemp_BlockedBy_SMSC__c', String.valueof(iCase.fbtemp_BlockedBy_SMSC__c));
        }else if(iCase.Template__c == '747'){
            query += 'SF_FIELD__c		=\'fbtemp_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_IdentityCardNumber__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Customer_Request__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Harassed_Contact__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Type_of_Harassment__c\'';
            query += ')';
            mapValue.put('fbtemp_Address__c', String.valueof(iCase.fbtemp_Address__c));
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_IdentityCardNumber__c', String.valueof(iCase.fbtemp_IdentityCardNumber__c));
            mapValue.put('fbtemp_Customer_Request__c', String.valueof(iCase.fbtemp_Customer_Request__c));
            mapValue.put('fbtemp_Harassed_Contact__c', String.valueof(iCase.fbtemp_Harassed_Contact__c));
            mapValue.put('fbtemp_Type_of_Harassment__c', String.valueof(iCase.fbtemp_Type_of_Harassment__c));
        }else if(iCase.Template__c == '660'){
            query += 'SF_FIELD__c		=\'fbtemp_Package__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Promotion_Program__c\'';
            query += ')';
            mapValue.put('fbtemp_Package__c', String.valueof(iCase.fbtemp_Package__c));
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Promotion_Program__c', String.valueof(iCase.fbtemp_Promotion_Program__c));
        }else if(iCase.Template__c == '3702'){
            query += 'SF_FIELD__c		=\'fbtemp_Date_Switch_Pre_Paid__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Balance_Amount__c\'';
            query += ')';
            mapValue.put('fbtemp_Date_Switch_Pre_Paid__c', String.valueof(iCase.fbtemp_Date_Switch_Pre_Paid__c));
            mapValue.put('fbtemp_Balance_Amount__c', String.valueof(iCase.fbtemp_Balance_Amount__c));
        }else if(iCase.Template__c == '3122'){
            query += 'SF_FIELD__c		=\'fbtemp_Tax_Code__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Customer_Request__c\'';
            query += ')';
            mapValue.put('fbtemp_Tax_Code__c', String.valueof(iCase.fbtemp_Tax_Code__c));
            mapValue.put('fbtemp_Customer_Request__c', String.valueof(iCase.fbtemp_Customer_Request__c));
        }else if(iCase.Template__c == '1382'){
            query += 'SF_FIELD__c		=\'fbtemp_Email_Address__c\'';
            query += ')';
            mapValue.put('fbtemp_Email_Address__c', String.valueof(iCase.fbtemp_Email_Address__c));
        }else if(iCase.Template__c == '3542'){
            query += 'SF_FIELD__c		=\'fbtemp_Cancel_Request_Type__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Package__c\'';
            query += ')';
            mapValue.put('fbtemp_Cancel_Request_Type__c', String.valueof(iCase.fbtemp_Cancel_Request_Type__c));
            mapValue.put('fbtemp_Package__c', String.valueof(iCase.fbtemp_Package__c));
        }else if(iCase.Template__c == '641'){
            query += 'SF_FIELD__c		=\'fbtemp_Contact_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'Street__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Permanent_or_temporary__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_DateTime__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Address__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Near__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Is_Using_Normally_at_this_time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_SIM_Type_Using__c\'';
            query += ')';
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
            mapValue.put('Street__c', String.valueof(iCase.Street__c));
            mapValue.put('fbtemp_Permanent_or_temporary__c', String.valueof(iCase.fbtemp_Permanent_or_temporary__c));
            mapValue.put('fbtemp_Time__c', String.valueof(iCase.fbtemp_Time__c));
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
            mapValue.put('fbtemp_Address__c', String.valueof(iCase.fbtemp_Address__c));
            mapValue.put('fbtemp_Near__c', String.valueof(iCase.fbtemp_Near__c));
            mapValue.put('fbtemp_Is_Using_Normally_at_this_time__c', String.valueof(iCase.fbtemp_Is_Using_Normally_at_this_time__c));
            mapValue.put('fbtemp_SIM_Type_Using__c', String.valueof(iCase.fbtemp_SIM_Type_Using__c));
        }else if(iCase.Template__c == '1883'){
            query += 'SF_FIELD__c		=\'fbtemp_Contact_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Staff__c\'';
            query += ')';
            mapValue.put('fbtemp_Contact_Phone__c', String.valueof(iCase.fbtemp_Contact_Phone__c));
            mapValue.put('fbtemp_Staff__c', String.valueof(iCase.fbtemp_Staff__c));
        }else if(iCase.Template__c == '3602'){
            query += 'SF_FIELD__c		=\'fbtemp_DateTime__c\'';
            //query += 'OR SF_FIELD__c	=\'fbtemp_Staff__c\'';
            query += ')';
            mapValue.put('fbtemp_DateTime__c', String.valueof(iCase.fbtemp_DateTime__c));
        }else if(iCase.Template__c == '3683' || iCase.Template__c == '3662' || iCase.Template__c == '3682' || iCase.Template__c == '3684' || iCase.Template__c == '3622' || iCase.Template__c == '3642'){
            query += 'SF_FIELD__c		=\'fbtemp_Errors_Area__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Error_Status__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Error_Time__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Service__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Current_Plan__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Left_Storage__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Used_Phone__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Display_Signal__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Check_Device_and_SIM_Errors__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Choose_correct_SIM_network_acces__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Other_information__c\'';
            query += ')';
            mapValue.put('fbtemp_Errors_Area__c', String.valueof(iCase.fbtemp_Errors_Area__c));
            mapValue.put('fbtemp_Error_Status__c', String.valueof(iCase.fbtemp_Error_Status__c));
            mapValue.put('fbtemp_Error_Time__c', String.valueof(iCase.fbtemp_Error_Time__c));
            mapValue.put('fbtemp_Service__c', String.valueof(iCase.fbtemp_Service__c));
            mapValue.put('fbtemp_Current_Plan__c', String.valueof(iCase.fbtemp_Current_Plan__c));
            mapValue.put('fbtemp_Left_Storage__c', String.valueof(iCase.fbtemp_Left_Storage__c));
            mapValue.put('fbtemp_Used_Phone__c', String.valueof(iCase.fbtemp_Used_Phone__c));
            mapValue.put('fbtemp_Display_Signal__c', String.valueof(iCase.fbtemp_Display_Signal__c));
            mapValue.put('fbtemp_Check_Device_and_SIM_Errors__c', String.valueof(iCase.fbtemp_Check_Device_and_SIM_Errors__c));
            mapValue.put('fbtemp_Choose_correct_SIM_network_acces__c', String.valueof(iCase.fbtemp_Choose_correct_SIM_network_acces__c));
            mapValue.put('fbtemp_Other_information__c', String.valueof(iCase.fbtemp_Other_information__c));
            
        }else if(iCase.Template__c == '729'){
            query += 'SF_FIELD__c		=\'fbtemp_Activation_Number__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Reason__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Activation_Date__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Received_Amount__c\'';
            query += 'OR SF_FIELD__c	=\'fbtemp_Missing_Amount__c\'';
            query += ')';
            mapValue.put('fbtemp_Activation_Number__c', String.valueof(iCase.fbtemp_Activation_Number__c));
            mapValue.put('fbtemp_Reason__c', String.valueof(iCase.fbtemp_Reason__c));
            mapValue.put('fbtemp_Activation_Date__c', String.valueof(iCase.fbtemp_Activation_Date__c));
            mapValue.put('fbtemp_Received_Amount__c', String.valueof(iCase.fbtemp_Received_Amount__c));
            mapValue.put('fbtemp_Missing_Amount__c', String.valueof(iCase.fbtemp_Missing_Amount__c));
        }
        
        List<MBF_Mapping_API__c> sobjList = (List<MBF_Mapping_API__c>)Database.query(query);
        String templateData;
        if(sobjList.size() >0){
            templateData = '{';
            for(MBF_Mapping_API__c iMaster: sobjList){
                String value = mapValue.get(iMaster.SF_FIELD__c);
                templateData += '"' + iMaster.CONTENT_ID__c + '":"' + value + '",';
            }
        }
        inputFb.template = templateData.replace('/', '').substring(0, templateData.length() - 1) + '}';
        // cho lên param => FB nó chấp nhật lên param, tuỳ từng ông chấp nhận lên param hoặc header của multipart/form-data
        body.inputFB = inputFb;
        // setbodyasblob
        String jsonBody = JSON.serialize(body.inputFB).replace('\\', '').replaceAll('"\\{', '{').replaceAll(',\\}"', '}').replaceAll('\\}"', '}');
        system.debug('jsonBody :' + jsonBody);
        String endpoint = Omni_Gateway__c.getInstance('Endpoint').Value__c + 'sf-api/v1/omni_create_fb';//  + EncodingUtil.urlEncode('inputFB=' + JSON.serialize(body.inputFB), 'UTF-8');
        String token = Omni_Gateway__c.getInstance('Token').Value__c + Omni_Gateway__c.getInstance('Token_2').Value__c + Omni_Gateway__c.getInstance('Token_3').Value__c + Omni_Gateway__c.getInstance('Token_4').Value__c + Omni_Gateway__c.getInstance('Token_5').Value__c;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Accept', '*/*');
        
        req.setHeader('Content-Type', 'multipart/form-data;boundary="' + BOUNDARY + '"');
        blob dataFile = makeBlobWithFile(base64Content, attachmentTitle, jsonBody);
        req.setBodyAsBlob(dataFile); // Dữ liệu dạng binary phải set theo blob
        
        req.setTimeout(45000);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        ResponseBody = response.getBody();
        system.debug('ResponseBody :' + ResponseBody);
        fromJSON resultAPI = new fromJSON();
        
		if(ResponseBody.length() > 0){
            resultAPI = (fromJSON) System.JSON.deserialize(ResponseBody, fromJSON.class);
        }
        iCase.Complain_Id__c = String.valueof(resultAPI.data.data);
        
        Update iCase;
        /*} catch (Exception ex) {        
            System.debug('R1_FeedbackAPI --> inputFB:' + ex.getMessage() + '-' + ex.getStackTraceString());	    
            throw new AuraHandledException(ex.getMessage());		
            
            // return null;
        }*/
        //return ResponseBody;
    }
    public class fromJSON {
        public cls_data data;
        public Integer http_code;	//200
        public String text;	//
        public Integer error_code;	//0
    }
    
    public class cls_data {
        public String code;	//API-000
        public String message;
        public String status;	//SUCCESS
        public String timestamp;	//2024-07-10 14:07:02
        public Integer elapsedTimeMs;	//710
        public String total;
        public Integer data;	//38403721
    }
    
    public class wrapperBody {
        public inputFbWrapper inputFB;
        public blob attachment;
    }
    
    public class inputFbWrapper {
        public String caseId;
        public String province;
        public String isdn;
        public String subId;
        public String address;
        public String idNo;
        public String contactName;
        public String contactIsdn;
        public String payAreaCode;
        public String payMethod;
        public String subType;
        public String custName;
        public String cenCode;
        public String template;
        public String businessType;
        public String memberName;
        public String cenCodeUser;
        public String requestTime;
        public String requestGroup;
        public Integer requestForm;
        public long requestSource;
        public String requestType;
        public long requestDetail;
        public Integer callOut;
        public String content;
        public Integer urgent;
        public String note;
        public String contractNo;
        public String custNo;
        public Decimal memberCode;
        public String referenceId;
        public Boolean closeNow;
    }
    
    public static inputFbWrapper parse(String json) {
        inputFbWrapper result = new inputFbWrapper();
        if(json.length() > 0){
            result = (inputFbWrapper) System.JSON.deserialize(json, inputFbWrapper.class);
        }
        
        return result;
    }
    
    public static Blob makeBlobWithFile(Blob attachBody,string fileName, string inputBodyFB){
        system.debug('fileName :' + fileName);
        system.debug('attachBody :' + attachBody);
        Blob formBlob = null;
        try {
            String mimeType = resolveMimeType(filename);
            String header = '--' + BOUNDARY + '\r\n' +
                + 'Content-Disposition: form-data;name=inputFB'+'\r\n\r\n'+inputBodyFB +
                + 'Content-Type: ' + mimeType + '\r\n'+
                + '--' + BOUNDARY + '\r\n' +
                + 'Content-Disposition: form-data; name=attachment;filename=' + fileName; 
            
            // Rebuild header if has another param in form data, each part need BOUNDARY and Content-Disposition
            
            String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
            while(headerEncoded.endsWith('=')){
                header += ' ';
                headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
            }
            formBlob = EncodingUtil.base64Decode(headerEncoded);
            String footer = '--' + BOUNDARY + '--';
            String bodyEncoded = '';
            
                system.debug('>>>PASSNULLFILE<<<');
                if(attachBody !=null){
                    bodyEncoded = EncodingUtil.base64Encode(attachBody);
                } 
            // String bodyEncoded = EncodingUtil.base64Encode(attachBody);
            System.debug('bodyEncoded: '+ bodyEncoded);
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            formBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
            system.debug('>>>PASSHAVEFILE<<<');
            String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
            system.debug('last4Bytes :' + last4Bytes);
                if(last4Bytes.endsWith('==')) {
                    last4Bytes = last4Bytes.substring(0,2) + '0K';
                    bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                    footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    formBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
                    system.debug('last4Bytes :' + last4Bytes);
                    
                } else if(last4Bytes.endsWith('=')) {
                    last4Bytes = last4Bytes.substring(0,3) + 'N';
                    bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                    footer = '\n' + footer;
                    footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    formBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
                } else {
                    footer = '\r\n' + footer;
                    footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    formBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
                }
        } catch(Exception e) {
            System.debug('makeBlobWithFile --> exception: ' + e.getMessage() + ' inline ' + e.getLineNumber());
        }
                
        return formBlob; // returning the form data as a blob 
    }
    
    private static String resolveMimeType(String fileName) {
        String fileType = fileName.substringAfterLast('.');
        String mimeType = 'image/png'; // fallback value
        if (fileType.equalsIgnoreCase('pdf')) {
            mimeType = 'application/pdf';
        } else if (fileType.equalsIgnoreCase('png')) {
            mimeType = 'image/png';
        } else if (fileType.equalsIgnoreCase('jpeg') || fileType.equalsIgnoreCase('jpg')) {
            mimeType = 'image/jpeg';
        } else if (fileType.equalsIgnoreCase('xls')) {
            mimeType = 'application/vnd.ms-excel';
        } else if (fileType.equalsIgnoreCase('xlsx')) {
            mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';            
        } else if (fileType.equalsIgnoreCase('doc')) {
            mimeType = 'application/msword';            
        } else if (fileType.equalsIgnoreCase('docx')) {
            mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';            
        }else if(fileType.equalsIgnoreCase('zip')){
            mimeType = 'application/zip';
        } else if(fileType.equalsIgnoreCase('mp4')){
            mimeType = 'video/mp4';
        }else if (fileType.equalsIgnoreCase('eml')) {
            mimeType = 'text/html';            
        }else{
            mimeType = 'image/png';
        }
        return mimeType;
    }
    
}