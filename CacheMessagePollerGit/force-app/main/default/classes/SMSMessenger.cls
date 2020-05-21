public with sharing class SMSMessenger {
     
    @AuraEnabled (cacheable=true)
    public static list<messenger__c> getSMSMessenges() {
        
        map<Id,messenger__c> MessagesMap = new map<Id,messenger__c>();
        string userId= userinfo.getUserId();
       
   Cache.OrgPartition orgPart = Cache.Org.getPartition('local.Message');
        if(!orgPart.contains(userId)){    
             
                for( messenger__c m: [select id, Read__c, URL__c, Subject__c from messenger__c where OwnerId=:userId and Read__c =false])
                {
                MessagesMap.put(m.id, m);
                }


             if(!MessagesMap.isempty())
            {
                orgPart.put(userId, MessagesMap );
             }
                
                
            }
        else{
            MessagesMap.clear();
            MessagesMap.putAll((Map<Id,Messenger__c>)orgPart.get(userId)); 
            
        }
        //system.debug('thevaluesincache are ' + MessagesMap.values());
        return MessagesMap.values();

    }
}