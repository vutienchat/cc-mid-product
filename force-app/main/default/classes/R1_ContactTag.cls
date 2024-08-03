public class R1_ContactTag {
    @AuraEnabled
    public static List<meta_tag__c> getTags(String recordId){
                
        List<meta_tag__c> result = [SELECT id, Tag__r.Name, Tag__c
                                    FROM meta_tag__c
                                    WHERE Case__c = : recordId
                                   ];
        
        return result;
    }
    
    @AuraEnabled
    public static String removeTag(String recordId, String tagName){
        String result;
        
        meta_tag__c deleteMetaTag = [SELECT id, Tag__r.Name, Tag__c
                                     FROM meta_tag__c
                                     WHERE Case__c = :recordId
                                     AND Tag__r.Name =: tagName
                                     LIMIT 1
                                    ];
        
        if(deleteMetaTag != null){
            delete deleteMetaTag;
            
            result ='Success';
        }
        
        return result;
    }
}