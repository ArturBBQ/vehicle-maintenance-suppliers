public without sharing class CaseTriggerHelper {
    
    /**
     * This method inside After update trigger which calculates the average rating 
     * for each closed Case associated with Accounts and updates the Average_rating__c field of the respective Accounts.
     * Additionally, it validates that Cases with 'Closed' status have a non-null Rating__c value.
     */
    public void countAverageAccountRating(List<Case> triggerNew) {
        
        Set<Id> accountIds = new Set<Id>();

        for(Case curCase : triggerNew){
            if (curCase.Status == 'Closed' && curCase.Rating__c == null) {
                curCase.addError('Fill up Rating field (from 1 to 5) before closing case.');
            } else {
                accountIds.add(curCase.AccountId);
            }
        }

        // Retrieve Account records along with their related Cases.
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, Average_rating__c, (SELECT Id, Rating__c FROM Cases WHERE Status = 'Closed') 
                                                            FROM Account 
                                                            WHERE Id IN :accountIds]);       

        // Perform an aggregate query to calculate average ratings and case counts.
        List<AggregateResult> groupedRes = [SELECT AccountId, COUNT(Id)cnt, AVG(Rating__c)avRating 
                                            FROM Case 
                                            WHERE AccountId IN: accountIds AND Status = 'Closed' 
                                            GROUP BY AccountId];
                                            
        // Update Account records with calculated average ratings.
        for(AggregateResult ar : groupedRes){
            Id recordId = (Id)ar.get('AccountId'); 
            accountMap.get(recordId).Average_rating__c = (Decimal)ar.get('avRating');   
        }
        
        update accountMap.values(); 
    }

}