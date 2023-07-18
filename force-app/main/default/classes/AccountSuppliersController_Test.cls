@isTest
private class AccountSuppliersController_Test {
    
    @TestSetup
    static void makeData() {
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
    static void test_getSuppliersByCity() {
        Supplier__c supplier = [SELECT Name, City__c, Location__Latitude__s, Location__Longitude__s 
                                FROM Supplier__c 
                                WHERE City__c = 'Test City' 
                                LIMIT 1];
        
        Double latitude = supplier.Location__Latitude__s.doubleValue();
        Double longitude = supplier.Location__Longitude__s.doubleValue();
        
        Test.startTest();
        List<Supplier__c> result = AccountSuppliersController.getSuppliersByCity(supplier.City__c, latitude, longitude);
        List<Supplier__c> result2 = AccountSuppliersController.getSuppliersByCity('nonexistent city', latitude, longitude);
        Test.stopTest();

        System.assertEquals(2, result.size());
        System.assertEquals('Supplier 1', result[0].Name);
        System.assertEquals('Supplier 2', result[1].Name);
        System.assertEquals(null, result2);
    }

    @IsTest
    static void test_bookAppointment() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Supplier__c testSupplier = [SELECT Id FROM Supplier__c LIMIT 1];
        Datetime appointmentTime = Datetime.now().addDays(1);
        Datetime impossibleAppointmentTime = Datetime.now().addDays(-1);

        Test.startTest();
            Case newCase = AccountSuppliersController.bookAppointment(
                testAccount.Id, testSupplier.Id, 'New', 'Phone', appointmentTime
            );
            Case impossibleCase = AccountSuppliersController.bookAppointment(
                testAccount.Id, testSupplier.Id, 'New', 'Phone', impossibleAppointmentTime
            );
        Test.stopTest();

        System.assertEquals(testAccount.Id, newCase.AccountId);
        System.assertEquals(testSupplier.Id, newCase.Supplier__c);
        System.assertEquals('New', newCase.Status);
        System.assertEquals('Phone', newCase.Origin);
        System.assertEquals(appointmentTime, newCase.Appointment_date_time__c);
        System.assertNotEquals(null, newCase);
        System.assertEquals(null, impossibleCase);
    } 

}