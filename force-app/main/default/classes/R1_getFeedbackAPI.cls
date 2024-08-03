/**
* @description       : The Class for get Feed back 
* @author            : ndmanh - GMS
* @last modified on  : 2024.05.31
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@RestResource(urlMapping='/getfb/*')
global with sharing class R1_getFeedbackAPI {
    @HttpPost
    global static void doPost(){
        Id customerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        
        Savepoint sp = Database.setSavepoint();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String resBody = req.requestBody.toString();
        dataWrapper idata = new dataWrapper();
        if(resBody.length() > 0){
            idata = (dataWrapper) System.JSON.deserialize(resBody, dataWrapper.class);
        }
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PAKH').getRecordTypeId();
        
        try{
            if(idata != null){    
                
                //ntluan update kiểm tra phone có trên hệ thống hay ko 28062024
                List<Contact> lstContact  = [SELECT Id, Name 
                                             FROM Contact 
                                             WHERE Phone =: idata.phone 
                                             LIMIT 1];
                //end update
                List<Case> lstCase = [SELECT id, COMPLAIN_ID__c, toLabel(Request_Type__c), Description, toLabel(Status), createddate
                                      FROM Case 
                                      WHERE Contact.Phone =: idata.phone
                                      AND recordtypeId =: recordTypeId
                                      AND CreatedDate = LAST_N_DAYS:90
                                      AND Status IN ('New','Working')
                                      ORDER BY CreatedDate DESC
                                      LIMIT 3
                                     ];
                
                if(lstCase.size() > 0){
                    WrapperSetAttributes body = new WrapperSetAttributes();
                    
                    valueSet resultStatus = new valueSet();
                    /* ntluan update change status error code 28062024
                    resultStatus.complain_error_code = '01';
                    body.set_attributes = resultStatus;
                    */
                    List<messages> lstMess = new List<messages>();
                    // default first mess
                    messages defaultMess = new messages();
                    defaultMess.type = 'text';
                    content defaultContent = new content();
                    defaultContent.text = 'Dưới đây là thông tin trạng thái xử lý ' + lstCase.size() + ' khiếu nại của thuê bao ' + idata.phone + ':';
                    
                    defaultMess.Content = defaultContent;
                    lstMess.add(defaultMess);
                    
                    for(Case iCase: lstCase){
                        messages iMess = new messages();
                        iMess.type = 'text';
                        // add content
                        content iContent = new content();
                        iContent.text = 'Mã khiếu nại:' + iCase.COMPLAIN_ID__c;
                        iContent.text += '\nLoại yêu cầu:' + iCase.Request_Type__c;
                        iContent.text += '\nNội dung tiếp nhận:' + iCase.Description;
                        iContent.text += '\nNgày tạo phiếu:' + iCase.CreatedDate;
                        iContent.text += '\nTrạng thái:' + iCase.Status;
                        
                        iMess.content = iContent;
                        lstMess.add(iMess);
                    }
                    if(lstMess.size() > 0) {
                        resultStatus.complain_error_code = '904';
                        body.set_attributes = resultStatus;
                    }
                    body.messages = lstMess;
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(JSON.serialize(body).replace('null', ''));
                    //ntluan update trường hợp ko có phone trên hệ thống 28062024
                } else if(lstContact.size() > 0 && lstCase.size() < 1){
                    valueSet result = new valueSet();
                    result.complain_error_code = '905';
                    WrapperSetAttributes body = new WrapperSetAttributes();
                    body.set_attributes = result;
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(JSON.serialize(body));
                } else {
                    valueSet result = new valueSet();
                    result.complain_error_code = '906';
                    WrapperSetAttributes body = new WrapperSetAttributes();
                    body.set_attributes = result;
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(JSON.serialize(body));
                }
                //end update
            } 
        } catch (Exception ex) {
            valueSet result = new valueSet();
            /* ntluan comment thay đổi mã lỗi 28062024
            result.complain_error_code = '904';
            */
            result.complain_error_code = '906';
            
            WrapperSetAttributes body = new WrapperSetAttributes();
            body.set_attributes = result;
            
            // Rollback transaction in case of error
            Database.rollback(sp);
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(body));
            
            Log_Utils.createLogApiInbound('getfb', req, '/api/getfb/', res);
            System.debug('Exception Message: ' + ex.getMessage());
        }
    }
    
    public class valueSet {
        public String complain_error_code;
    }
    
    public class content{
        public String text;
    }
    
    public class messages {
        public String type;
        public content content;
    }
    
    public class WrapperSetAttributes {
        public valueSet set_attributes;
        public List<messages> messages;
    }
    
    public class dataWrapper {
        public String phone;
    }
    
}