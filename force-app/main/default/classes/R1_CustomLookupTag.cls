public class R1_CustomLookupTag {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String caseId, List<meta_tag__c> lstTags) {
        List<String> lstStringTags = new List<String>();
        if(lstTags.size() > 0){
            for(meta_tag__c iTag: lstTags){
               lstStringTags.add(iTag.Tag__c);
            }
        }
        Set<String> IdCheck = new Set<String>();
        List < sObject > returnList = new List < sObject > ();
        
        String searchKey ;

        String textSearch ='%' + searchKeyWord + '%';
        String sQuery = '';
        List < sObject > lstOfRecords = new List < sObject >();
        
        String query = 'Select Tag__r.Name from meta_tag__c WHERE Tag__c NOT IN :lstStringTags ';
        if(searchKeyWord != null) query += 'AND Tag__r.Name LIKE: textSearch GROUP BY Tag__r.Name limit 5';
        else query += 'GROUP BY Tag__r.Name limit 5';
        system.debug(query);
        lstOfRecords =  Database.query(query);
        system.debug(lstOfRecords);
        if(lstOfRecords.size() > 0 && lstOfRecords != null){
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
                IdCheck.add(obj.id);            
            }
        }
        system.debug(returnList);
        return returnList;
    }
    
    @AuraEnabled
    public static String addTag(String nameTag, String caseId) {
        String result;
        
        Tag__c iTag = [SELECT id, Name FROM Tag__c WHERE Name =: nameTag];
        
        case c = [SELECT id, ContactId FROM Case WHERE id= :caseId];
        
        meta_tag__c newMetaTag = new meta_tag__c();
        newMetaTag.Contact__c = c.ContactId;
        newMetaTag.Case__c = caseId;
        newMetaTag.Tag__c = iTag.Id;
        newMetaTag.Name = iTag.Name;
        
        insert newMetaTag;
        
        result = 'Success';
        
        return result;
    }
    
    @AuraEnabled
    public static String createTag(String nameTag, String caseId) {
        String result;
        
        Tag__c iTag = new Tag__c();
        iTag.Name = nameTag;
        insert iTag;
        
        case c = [SELECT id, ContactId FROM Case WHERE id= :caseId];
        
        meta_tag__c newMetaTag = new meta_tag__c();
        newMetaTag.Contact__c = c.ContactId;
        newMetaTag.Case__c = caseId;
        newMetaTag.Tag__c = iTag.Id;
        newMetaTag.Name = iTag.Name;
        
        insert newMetaTag;
        
        result = 'Success';
        
        return result;
    }
}