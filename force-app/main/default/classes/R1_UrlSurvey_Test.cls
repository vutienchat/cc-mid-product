/**
* @description       : The Class for test R1_UrlSurvey
* @author            : nmquang - GMS
* @last modified on  : 07/03/2024
* @last modified by  : Nguyen Minh Quang (nguyenminhquang0325@gmail.com)
* @history           :    date                    author                      content
**/

@isTest
private class R1_UrlSurvey_Test {
    @isTest
    static void testGetUrlSurvey() {
        // Tạo Case
        Case c = new Case();
        c.Subject = 'test';
        insert c;
        
        // Tạo Contact
        Contact ct = new Contact();
        ct.Phone = '0982241317';
        ct.LastName = 'test';
        insert ct;
        
        // Tạo dữ liệu giả lập cho GMS_Lab_FPT__Chat_Transcription__c
        GMS_Lab_FPT__Chat_Transcription__c chatSession = new GMS_Lab_FPT__Chat_Transcription__c();
        chatSession.GMS_Lab_FPT__Case__c = c.Id; // Sử dụng Id của Case
        chatSession.GMS_Lab_FPT__Contact__c = ct.Id; // Sử dụng Id của Contact
        insert chatSession;

        // Gọi phương thức getUrlSurvey
        String recordId = chatSession.Id;
        String surveyUrl = R1_UrlSurvey.getUrlSurvey(recordId);

        // Kiểm tra kết quả
    }
}