@isTest
public class GMS_DeleteWorkShift_BatchJob_Test {
    @isTest
    static void testBatchJob() {
        // Tạo dữ liệu giả cho WorkShip_Line_Item__c
        List<WorkShip_Line_Item__c> workShipItems = new List<WorkShip_Line_Item__c>();
        for (Integer i = 0; i < 5; i++) {
            workShipItems.add(new WorkShip_Line_Item__c(
                Time__c = String.valueOf(10 + i),
                Date__c = Date.today().addDays(i),
                KeyFlow__c = 'Test Key ' + i
            ));
        }
        insert workShipItems;
        
        // Tạo batch job với danh sách các bản ghi cần xóa
        GMS_DeleteWorkShift_BatchJob batchJob = new GMS_DeleteWorkShift_BatchJob(workShipItems);
        
        // Chạy batch job trong môi trường kiểm thử
        Test.startTest();
        ID batchJobId = Database.executeBatch(batchJob);
        Test.stopTest();
    }
}