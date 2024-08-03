@istest
public class CreateWorkShipScreen_Test {
    @istest
    public static void Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            EmailEncodingKey = 'UTF-8',
            Alias = 'tuser',
            TimeZoneSidKey = 'Asia/Ho_Chi_Minh',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            Region__c = '1', // Custom field
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Phone = '1234567890',
            Partner__c = 'C1_MFS'
        );
        insert testUser;
        
        User testUser2 = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser12@example.com',
            Username = 'testuser12@example.com' + System.currentTimeMillis(),
            EmailEncodingKey = 'UTF-8',
            Alias = 'tuser',
            TimeZoneSidKey = 'Asia/Ho_Chi_Minh',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            Region__c = '1', // Custom field
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Phone = '1234567890',
            Partner__c = 'C1_MFS'
        );
        insert testUser2;
        
        User testUser3 = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser123@example.com',
            Username = 'testuser123@example.com' + System.currentTimeMillis(),
            EmailEncodingKey = 'UTF-8',
            Alias = 'tuser',
            TimeZoneSidKey = 'Asia/Ho_Chi_Minh',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            Region__c = '1', // Custom field
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Phone = '1234567890',
            Partner__c = 'C1_MFS'
        );
        insert testUser3;
        
        
        
        
        Master_Data__c mdt = new Master_Data__c();
        mdt.Name = 'Test';
        mdt.Agent_Code__c = '1234';
        mdt.Email__c = 'test1234@gmail.com';
        mdt.Unit_by_region__c = 'C1_MFS';
        mdt.User_uses__c = testUser.Id;
        insert mdt;
        
        Master_Data__c mdt2 = new Master_Data__c();
        mdt2.Name = 'Test';
        mdt2.Agent_Code__c = '12345';
        mdt2.Email__c = 'test12345@gmail.com';
        mdt2.Unit_by_region__c = 'C1_MFS';
        insert mdt2;
        
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        Work_Management__c workManagement = new Work_Management__c();
        workManagement.Name = 'Test Work Management';
        workManagement.User_Using__c = testUser.Id;
        workManagement.Working_Date__c = Date.today();
        workManagement.recordTypeId = idPlan;
        workManagement.Clock_in__c = datetime.now().addhours(-3);
        workManagement.Shift__c = '8:00-14:00';
        workManagement.Agent__c = mdt.Id; 
        workManagement.Channel__c = 'Kênh số';
        insert workManagement; 
        
        date myDate = date.today();
        String month = string.valueOf(myDate.month());
        String year = string.valueOf(myDate.year());
        
        List<String> lstAgent = new List<String>{mdt.Id};
        List<String> lstAgent2 = new List<String>{mdt2.Id};
                
        List<CreateWorkShipScreen.FlowInputs> lstflowInput = new List<CreateWorkShipScreen.FlowInputs>();
        CreateWorkShipScreen.FlowInputs fl = new CreateWorkShipScreen.FlowInputs();
        fl.idAgent = lstAgent;
        fl.fromDate = date.today();
        fl.toDate = date.today();
        fl.partner = 'C1_MFS';
        fl.fromTime = '8:00';
        fl.toTime = '14:00';
        lstflowInput.add(fl);
        CreateWorkShipScreen.createListWorkShift(lstflowInput);
        
        List<CreateWorkShipScreen.FlowInputs> lstflowInput2 = new List<CreateWorkShipScreen.FlowInputs>();
        CreateWorkShipScreen.FlowInputs fl2 = new CreateWorkShipScreen.FlowInputs();
        fl2.idAgent = lstAgent2;
        fl2.fromDate = date.today();
        fl2.toDate = date.today();
        fl2.partner = 'C1_MFS';
        fl2.fromTime = '15:00';
        fl2.toTime = '22:00';
        lstflowInput2.add(fl2);
        CreateWorkShipScreen.createListWorkShift(lstflowInput2);
        
    }
}