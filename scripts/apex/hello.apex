// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/*System.debug('Hello World!');
*/

Supplier__c act=[SELECT Name 
             FROM Supplier__c 
             LIMIT 1];

List<sObject> lst=new List<sObject>();
lst.add(act);

if(lst[0].getSObjectType() == Schema.Supplier__c.getSObjectType()) {
    System.debug('Supplier__c.getSObjectType()---> ' + Supplier__c.getSObjectType());

}