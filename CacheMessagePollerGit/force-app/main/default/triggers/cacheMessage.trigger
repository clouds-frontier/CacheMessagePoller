trigger cacheMessage on Messenger__c (after insert,after update, after delete, after undelete ) 
{
    Cache.OrgPartition orgPart = Cache.Org.getPartition('local.Message');
                 
    if(trigger.isAfter)
    {
   
        if(trigger.isInsert)
        {
            Set<id> userIdsSet = new Set<Id>();    
            Map<id,integer> userTaskCountMap = new map<id,integer>();
          //  map<id,message__c> messagesMap=new map<id,message__c>();
            
            // update coutner by user
             for (Messenger__c m: trigger.new)
             {
                 //assuming inerts messages are always unread if needed check can be put to check if read__c is false
                 userIdsSet.add(m.OwnerId);
                 if(orgPart.contains(m.OwnerId))
                 {
                          map<Id, Messenger__c> messagesMap = (Map<Id,Messenger__c>) orgPart.get(m.OwnerId);
                            messagesMap.put(m.id,m); 
                            orgPart.remove(m.OwnerId);
                            orgPart.put(m.OwnerId,messagesMap);// using maps to help remvoing read messages on update
                         
                  }                            
             }
            
           }
        
            if(trigger.isUpdate)
            {
                
                
             for (Messenger__c m: trigger.new)
             {
             if(orgPart.contains(m.OwnerId)) // if user never loaded the component or ttl has expired ie logged out do nothing
                     {
                 if (m.Read__c != trigger.oldmap.get(m.id).read__c)
                 {    
                     
                          
                         map<id,Messenger__c> messagesMap =  (Map<Id,Messenger__c>) orgPart.get(m.OwnerId);
                         //here is when we decide to subtract or add
                         
                         
                         
                         if(m.read__c==true)
                         {
                                if(messagesMap.containsKey(m.id))
                                {
                                 messagesMap.remove(m.id);
                                 }
                                orgPart.remove(m.OwnerId);
                                if(messagesMap!=Null)
                                {
                                 orgPart.put(m.OwnerId,messagesMap);
                                }
                         }
                         else
                         {
                             if(m.read__c==false)
                             {
                                if(!messagesMap.containsKey(m.id))
                                {
                                messagesMap.put(m.id,m);
                                orgPart.remove(m.OwnerId);
                                orgPart.put(m.OwnerId,messagesMap);
                                }
                             }
                             
                         }
                             
                      }
                 }
              
                                         
             }
                
            }
            if(trigger.isDelete)
            {
             // update counter by user
              for (Messenger__c m: trigger.new)
             {
                 if(orgPart.contains(m.OwnerId))
                 {
                 map<id,Messenger__c> messagesMap = (Map<Id,Messenger__c>) orgPart.get(m.OwnerId);
                  if(m.read__c==false)
                   {
                       if(messagesMap.containsKey(m.id))
                                {
                                 messagesMap.remove(m.id);
                                 }
                                orgPart.remove(m.OwnerId);
                                if(messagesMap!=Null)
                                {
                                 orgPart.put(m.OwnerId,messagesMap);
                                }
                   }
                 }
             }
              
            }
        
        
        if(trigger.isUndelete)
            {
             // update counter by user
              for (Messenger__c m: trigger.new)
             {
                 if(orgPart.contains(m.OwnerId))
                 {
                 map<id,Messenger__c> messagesMap = (Map<Id,Messenger__c>) orgPart.get(m.OwnerId);
                  if(m.Read__c==false)
                   {
                        if(!messagesMap.containsKey(m.id))
                                {
                                messagesMap.put(m.id,m);
                                orgPart.remove(m.OwnerId);
                                orgPart.put(m.OwnerId,messagesMap);
                                }
                   }
                 }
             }
              
            }
        
    }

}