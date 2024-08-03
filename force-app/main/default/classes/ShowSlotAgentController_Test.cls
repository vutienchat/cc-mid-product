@isTest
public class ShowSlotAgentController_Test {
    @isTest
    static void testQuerySlot() {
        // Tạo dữ liệu giả cho WorkShip_Line_Item__c
        Date today = Date.today();
        WorkShip_Line_Item__c item1 = new WorkShip_Line_Item__c(
            Time__c = '10',
            Date__c = today,
            KeyFlow__c = 'Test Key 1' 
        );
        WorkShip_Line_Item__c item2 = new WorkShip_Line_Item__c(
            Time__c = '11',
            Date__c = today,
            KeyFlow__c = 'Test Key 2'
        );
        insert new List<WorkShip_Line_Item__c>{item1, item2};
            
            // Gọi method querySlot
            Test.startTest();
        List<ShowSlotAgentController.workShipResultWrapper> result = ShowSlotAgentController.querySlot(today, today, 'Test Partner');
        Test.stopTest();
        
        // Kiểm tra kết quả
        System.assertEquals(2, result.size(), 'Kết quả trả về phải có 2 phần tử');
        for (ShowSlotAgentController.workShipResultWrapper wrapper : result) {
            System.assertEquals('10', wrapper.userSystem, 'User system phải là 10');
            System.assert(wrapper.userUsing != null, 'User using không được null');
            System.assert(wrapper.hour != null, 'Hour không được null');
            System.assert(wrapper.day != null, 'Day không được null');
            System.assert(wrapper.userMissing != null, 'User missing không được null');
        }
    }
    
    @isTest
    static void testDeleteWorkManagerment() {
        // Tạo dữ liệu giả cho WorkShip_Line_Item__c
        WorkShip_Line_Item__c item1 = new WorkShip_Line_Item__c(
            Time__c = '10',
            Date__c = Date.today(),
            KeyFlow__c = 'Test Key 1'
        );
        WorkShip_Line_Item__c item2 = new WorkShip_Line_Item__c(
            Time__c = '11',
            Date__c = Date.today(),
            KeyFlow__c = 'Test Key 1'
        );
        insert new List<WorkShip_Line_Item__c>{item1, item2};
            
            // Gọi method deleteWorkManagerment
            Test.startTest();
        ShowSlotAgentController.deleteWorkManagerment('Test Key 1');
        Test.stopTest();
        
        // Kiểm tra kết quả
        List<WorkShip_Line_Item__c> lst = [SELECT Id FROM WorkShip_Line_Item__c WHERE KeyFlow__c = 'Test Key 1'];
    }
}