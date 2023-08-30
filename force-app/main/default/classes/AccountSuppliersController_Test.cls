@isTest
private class AccountSuppliersController_Test {
    
    @TestSetup
    static void makeData() {
        Contact testContact = new Contact(
            LastName = 'Test Contact'
            );
        insert testContact;

        Account testAccount = new Account(
            Name = 'Test Account', 
            BillingCity = 'Test City', 
            Location__Latitude__s = 50.485536, 
            Location__Longitude__s = 30.58739
            );
        insert testAccount;

        Supplier__c testSupplier1 = new Supplier__c(
            Name = 'Supplier 1', 
            City__c = 'Test City',
            Billing_Address__Street__s = 'Test Street', 
            Location__Latitude__s = 50.445944, 
            Location__Longitude__s = 30.445072
            );
        Supplier__c testSupplier2 = new Supplier__c(
            Name = 'Supplier 2', 
            City__c = 'Test City',
            Billing_Address__Street__s = 'Test Street', 
            Location__Latitude__s = 50.475536, 
            Location__Longitude__s = 30.58707
            );
        insert new List<Supplier__c>{testSupplier1, testSupplier2};
    }


    @IsTest
    static void test_getSuppliersByCity_Positive() {
        Account testAccount = [SELECT BillingCity, Location__Latitude__s,  Location__Longitude__s  FROM Account LIMIT 1];
        List<Supplier__c> result = AccountSuppliersController.getSuppliersByCity(
            testAccount.BillingCity, testAccount.Location__Latitude__s.doubleValue(), testAccount.Location__Longitude__s.doubleValue()
            );
        System.assertEquals(2, result.size());
    }

    @IsTest
    static void test_bookAppointment() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Supplier__c testSupplier = [SELECT Id FROM Supplier__c LIMIT 1];
        Datetime appointmentTime = Datetime.now().addDays(1);

        Test.startTest();
            Case newCase = AccountSuppliersController.bookAppointment(
                testContact.Id, testAccount.Id, testSupplier.Id, 'New', 'Phone', appointmentTime
            );
        Test.stopTest();

        System.assertEquals(testAccount.Id, newCase.AccountId);
        System.assertEquals(testSupplier.Id, newCase.Supplier__c);
        System.assertEquals('New', newCase.Status);
        System.assertEquals('Phone', newCase.Origin);
        System.assertEquals(appointmentTime, newCase.Appointment_date_time__c);
        System.assertNotEquals(null, newCase);
    } 

    @IsTest
    static void test_bookAppointment_Negative() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Supplier__c testSupplier = [SELECT Id FROM Supplier__c LIMIT 1];
        Datetime impossibleAppointmentTime = Datetime.now().addDays(-1);

        Test.startTest();
            try {
                Case impossibleCase = AccountSuppliersController.bookAppointment(
                    testContact.Id, testAccount.Id, testSupplier.Id, 'New', 'Phone', impossibleAppointmentTime
                );
                System.assert(false, 'Expected exception not thrown.');
            } catch (AuraHandledException e) {
                System.assertEquals('Script-thrown exception', e.getMessage());
            }
        Test.stopTest();
    } 

}