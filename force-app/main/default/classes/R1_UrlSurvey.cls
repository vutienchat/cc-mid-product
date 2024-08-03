/**
* @description       : The Class for Button Create Call Out Task
* @author            : ndmanh - GMS
* @last modified on  : 2024.06.17
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_UrlSurvey {
    @AuraEnabled 
    public static String getUrlSurvey(String recordId){
        String result;
        GMS_Lab_FPT__Chat_Transcription__c chatSession = [SELECT id, GMS_Lab_FPT__Case__c, GMS_Lab_FPT__Case__r.Contact.Phone
                                                          FROM GMS_Lab_FPT__Chat_Transcription__c 
                                                          WHERE id =: recordId];
        
        String parameter = EncodingUtil.base64Encode(blob.valueof('recordId=' + chatSession.GMS_Lab_FPT__Case__c + '&phone=' + chatSession.GMS_Lab_FPT__Case__r.Contact.Phone));
        
        result = 'Cam on Quy khach da dong hanh cung MBF trong suot thoi gian qua. Kinh mong Quy khach co the danh it phut thuc hien khao sat de giup Chung toi ghi nhan va nang cao cong tac CSKH. Click vao link: \r https://flow-force-2116--mbfdev.sandbox.my.salesforce-sites.com/Survey?' +  parameter + '\r Tran trong cam on quy khach.';
        
        return result;
    }
}