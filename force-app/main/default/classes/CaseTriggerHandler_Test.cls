@isTest 
private class CaseTriggerHandler_Test {

    @TestSetup
    static void makeData() {
        Account testAccount = new Account(
            Name = 'Test Account', 
            BillingCity = 'Test City', 
            Location__Latitude__s = 50.485536, 
            Location__Longitude__s = 30.58739
            );
        insert testAccount;

        Supplier__c testSupplier = new Supplier__c(
            Name = 'Supplier', 
            City__c = 'Test City',
            Billing_Address__Street__s = 'Test Street', 
            Location__Latitude__s = 50.445944, 
            Location__Longitude__s = 30.445072
            );
        insert testSupplier;

        Case testCase1 = new Case(
            AccountId = testAccount.Id, 
            Supplier__c = testSupplier.Id, 
            Appointment_date_time__c = Datetime.now().addDays(1)
            );
        Case testCase2 = new Case(
            AccountId = testAccount.Id, 
            Supplier__c = testSupplier.Id, 
            Appointment_date_time__c = Datetime.now().addDays(1)
            );
        insert new List<Case>{testCase1, testCase2};
    }
    
    @IsTest
    static void test_countAverageAccountRating() {
        Account testAccount = [SELECT Id, Name, Average_rating__c FROM Account LIMIT 1];
        List<Case> testCases = [SELECT AccountId, Supplier__c, Status, Rating__c FROM Case];
        
        testCases[0].Status = 'Closed';
        testCases[0].Rating__c = 2;
        testCases[1].Status = 'Closed';
        testCases[1].Rating__c = 4;

        Test.startTest();
            update new List<Case>{testCases[0], testCases[1]};
        Test.stopTest();

        testAccount = [SELECT Id, Name, Average_rating__c FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(3.0, testAccount.Average_rating__c);
    }

    @IsTest
    static void test2_countAverageAccountRatingNegative() {
        Case testCase = [SELECT AccountId, Supplier__c, Status, Rating__c FROM Case LIMIT 1];
        testCase.Status = 'Closed';
        testCase.Rating__c = null;
        
        Test.startTest();
            Database.SaveResult result = Database.update(testCase, false);
        Test.stopTest();
        
        System.assertEquals('Fill up Rating field (from 1 to 5) before closing case.',
                        result.getErrors()[0].getMessage());
    }    

}