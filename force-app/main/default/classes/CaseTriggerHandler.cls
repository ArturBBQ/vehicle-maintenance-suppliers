public with sharing class CaseTriggerHandler {
    
    public static void countAverageAccountRating(List<Case> triggerNew) {
        
        Set<Id> accountIds = new Set<Id>();

        for(Case curCase : triggerNew){
            if (curCase.Status == 'Closed' && curCase.Rating__c == null) {
                curCase.addError('Fill up Rating field (from 1 to 5) before closing case.');
            } else {
                accountIds.add(curCase.AccountId);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, Average_rating__c, (SELECT Id, Rating__c FROM Cases WHERE Status = 'Closed') 
                                                            FROM Account 
                                                            WHERE Id IN :accountIds]);                            

        List<AggregateResult> groupedRes = [SELECT AccountId, COUNT(Id)cnt, AVG(Rating__c)avRating 
                                            FROM Case 
                                            WHERE AccountId IN: accountIds AND Status = 'Closed' 
                                            GROUP BY AccountId];
        
        for(AggregateResult ar : groupedRes){
            Id recordId = (Id)ar.get('AccountId'); 
            accountMap.get(recordId).Average_rating__c = (Decimal)ar.get('avRating');   
        }
        
        update accountMap.values(); 
    }

}