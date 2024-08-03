/*
*********************************************************
Apex Class Name    : GMS_DeleteWorkShift_BatchJob
Created Date       : 10/05/2024
@description       : Xử lý xóa workshift_Lineitem 
@author            : ntluan (GMS)
*********************************************************
*/
public class GMS_DeleteWorkShift_BatchJob implements Database.Batchable<SObject> {
    private List<SObject> recordsToDelete;

    // Constructor to accept a list of records to delete
    public GMS_DeleteWorkShift_BatchJob(List<SObject> records) {
        this.recordsToDelete = records;
    }

    // Start method to specify the query or collection
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Create a dynamic query based on the record IDs
        List<Id> recordIds = new List<Id>();
        for (SObject record : recordsToDelete) {
            recordIds.add(record.Id);
        }
        String query = 'SELECT Id FROM ' + recordsToDelete[0].getSObjectType() + ' WHERE Id IN :recordIds';
        return Database.getQueryLocator(query);
    }

    // Execute method to process each batch of records
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        try {
            // Delete the records in the current scope
            system.debug(scope.size());
            delete scope;
        } catch (Exception e) {
            // Handle exception
            System.debug('Error deleting records: ' + e.getMessage());
        }
    }

    // Finish method to execute post-batch job actions
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished');
    }
}