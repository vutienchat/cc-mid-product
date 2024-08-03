/**
* @description       : The Class for Handle LWC asign Supervior
* @author            : dvthanh - GMS
* @create time	     : 2024.07.06
* @last modified on  : 2024.07.06
* @last modified by  : Do Viet Thanh(vthanh3011@gmail.com)
* @history           :    date                    author                      content
**/
@isTest
private class HandleAsignSuperviorLWC_Test {

    @testSetup
    static void setup() {
        // Get valid picklist values for Unit_by_region__c
        List<Schema.PicklistEntry> unitPicklistValues = Schema.Master_Data__c.Unit_by_region__c.getDescribe().getPicklistValues();
        List<String> unitValues = new List<String>();
        for (Schema.PicklistEntry entry : unitPicklistValues) {
            unitValues.add(entry.getValue());
        }
        List<gmscloud__GMS_Chat_Transcription__c> chatTranscriptions = new List<gmscloud__GMS_Chat_Transcription__c>();
        chatTranscriptions.add(new gmscloud__GMS_Chat_Transcription__c(
            gmscloud__Status__c = 'Completed',
            gmscloud__Channel__c = 'Web',
            gmscloud__EndTime__c = DateTime.now(),
            gmscloud__ChatDuration__c = 30
        ));
        chatTranscriptions.add(new gmscloud__GMS_Chat_Transcription__c(
            gmscloud__Status__c = 'Completed',
            gmscloud__Channel__c = 'Mobile',
            gmscloud__EndTime__c = DateTime.now(),
            gmscloud__ChatDuration__c = 45
        ));
        chatTranscriptions.add(new gmscloud__GMS_Chat_Transcription__c(
            gmscloud__Channel__c = 'Web',
            gmscloud__EndTime__c = DateTime.now(),
            gmscloud__ChatDuration__c = 15
        ));
        insert chatTranscriptions;
        
        
        List<GMS_Lab_FPT__Chat_Transcription__c> chatTranscriptions2 = new List<GMS_Lab_FPT__Chat_Transcription__c>();
        chatTranscriptions2.add(new GMS_Lab_FPT__Chat_Transcription__c(
            GMS_Lab_FPT__Status__c = 'Ended by agent',
            GMS_Lab_FPT__Chat_Bot_Channel__c = 'Web',
            GMS_Lab_FPT__End_Time__c = DateTime.now()  
        ));
        chatTranscriptions2.add(new GMS_Lab_FPT__Chat_Transcription__c(
            GMS_Lab_FPT__Status__c = 'Ended by agent',
            GMS_Lab_FPT__Chat_Bot_Channel__c = 'Mobile',
            GMS_Lab_FPT__End_Time__c = DateTime.now()
        ));
        chatTranscriptions2.add(new GMS_Lab_FPT__Chat_Transcription__c(
            GMS_Lab_FPT__Chat_Bot_Channel__c = 'Web',
            GMS_Lab_FPT__End_Time__c = DateTime.now()
        ));
        insert chatTranscriptions2;
        

        
        List<GMS_Lab_FPT__Chat_Transcription__c> chatTranscriptions3 = new List<GMS_Lab_FPT__Chat_Transcription__c>();
        chatTranscriptions3.add(new GMS_Lab_FPT__Chat_Transcription__c(
            GMS_Lab_FPT__Status__c = 'Ended by agent',
            GMS_Lab_FPT__Chat_Bot_Channel__c = 'Web',
            GMS_Lab_FPT__End_Time__c = DateTime.now()
        ));
        chatTranscriptions3.add(new GMS_Lab_FPT__Chat_Transcription__c(
            GMS_Lab_FPT__Status__c = 'Ended by agent',
            GMS_Lab_FPT__Chat_Bot_Channel__c = 'Mobile',
            GMS_Lab_FPT__End_Time__c = DateTime.now()
        ));
        chatTranscriptions3.add(new GMS_Lab_FPT__Chat_Transcription__c(
            GMS_Lab_FPT__Chat_Bot_Channel__c = 'Web',
            GMS_Lab_FPT__End_Time__c = DateTime.now()
        ));
        insert chatTranscriptions3; 
        
        // Insert test data for Master_Data__c and Survey_Template__c
        List<Master_Data__c> masterDataList = new List<Master_Data__c>();
        for (Integer i = 0; i < 10; i++) {
            Master_Data__c md = new Master_Data__c();
            md.Name = 'Test Name ' + i;
            md.Unit_by_region__c = unitValues[Math.mod(i, unitValues.size())];
            md.Role__c = (Math.mod(i, 2) == 0) ? 'GSV' : 'Agent';
            masterDataList.add(md);
        }
        insert masterDataList;

        List<Survey_Template__c> surveyTemplateList = new List<Survey_Template__c>();
        for (Integer i = 0; i < 5; i++) {
            Survey_Template__c st = new Survey_Template__c();
            st.Name = 'Template ' + i;
            surveyTemplateList.add(st);
        }
        insert surveyTemplateList;

        // Query the existing record types for use in tests
        List<RecordType> recordTypeList = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Case' LIMIT 3];
    }

    @isTest
    static void testGetOptionUnits() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getOptionUnits();
        Test.stopTest();
    }

    @isTest
    static void testGetOptionTeams() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getOptionTeams();
        Test.stopTest();
    }

    @isTest
    static void testGetOptionTypes() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getOptionTypes();
        Test.stopTest();
    }

    @isTest
    static void testGetOptionReason() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getOptionReason();
        Test.stopTest();
    }

    @isTest
    static void testGetOptionSupervisor() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getOptionSupervisor(null, '2');
        Test.stopTest();
    }

    @isTest
    static void testGetOptionAgents() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getOptionAgents(null, '1');
        Test.stopTest();
    }

    @isTest
    static void testGetTemplate() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getTemplate();
        Test.stopTest();
    }

    @isTest
    static void testGetRecordTypeOfCase() {
        Test.startTest();
        List<HandleAsignSuperviorLWC.OptionWrapper> options = HandleAsignSuperviorLWC.getRecordTypeOfCase();
        Test.stopTest();
    }

    @isTest
    static void testGetDataList() {
        HandleAsignSuperviorLWC.ListRequest request = new HandleAsignSuperviorLWC.ListRequest();
        request.zalo = true;
        request.facebook = true;
        request.chatbot = true;
        request.task = true;
        request.percentOfData = 50;

        Test.startTest();
        List<HandleAsignSuperviorLWC.DataListWapper> dataList = HandleAsignSuperviorLWC.getDataList(request, false, '', 'ASC');
        Test.stopTest();
    }

    @isTest
    static void testAsignData() {
        // Query to get a valid template Id
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
        
        // Query to get a valid supervisor Id
        Master_Data__c supervisor = [SELECT Id FROM Master_Data__c WHERE Role__c = 'GSV' LIMIT 1];
        
        // Query to get a valid agent Id
        Master_Data__c agent = [SELECT Id FROM Master_Data__c WHERE Role__c = 'Agent' LIMIT 1];

        // Generate a valid test ID for 'testId'
        Master_Data__c masterData = [SELECT Id FROM Master_Data__c LIMIT 1];
        String testId = masterData.Id;
        
        task t = new task();
        t.Subject = 'test';
        insert t;

        List<HandleAsignSuperviorLWC.SelectAsignWapper> selectData = new List<HandleAsignSuperviorLWC.SelectAsignWapper>();
        HandleAsignSuperviorLWC.SelectAsignWapper selectAsignWapper = new HandleAsignSuperviorLWC.SelectAsignWapper(t.Id, 'Task', agent.Id);
        selectData.add(selectAsignWapper);

        HandleAsignSuperviorLWC.ListAsignData data = new HandleAsignSuperviorLWC.ListAsignData();
        data.template = template.Id;
        data.supervior = supervisor.Id;
        data.timeAsign = '1';
        data.exprieDate = Date.today();

        Test.startTest();
        Boolean result = HandleAsignSuperviorLWC.asignData(selectData, data); 
        Test.stopTest();
    }
}