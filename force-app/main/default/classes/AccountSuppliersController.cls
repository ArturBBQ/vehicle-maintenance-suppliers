public with sharing class AccountSuppliersController {

    @AuraEnabled
    public static List<Supplier__c> getSuppliersByCity(String accountCity, Double accountLatitude, Double accountLongitude) {
        List<Supplier__c> suppliers = [
            SELECT Name, City__c, Billing_Address__Street__s, Location__Latitude__s, Location__Longitude__s,
            DISTANCE(Location__c, GEOLOCATION(:accountLatitude, :accountLongitude), 'km') 
            FROM Supplier__c 
            WHERE City__c = :accountCity
            ORDER BY DISTANCE(Location__c, GEOLOCATION(:accountLatitude, :accountLongitude), 'km')
        ];
        if (suppliers.isEmpty()) {
            return null;
        }
        return suppliers;
    }

    @AuraEnabled
    public static Case bookAppointment(String accountId, String supplierId, String status, 
                                       String caseOrigin, Datetime appointmentTime) {
        try {
            Case newCase = new Case(
                AccountId = accountId,
                Supplier__c = supplierId,
                Origin = caseOrigin,
                Status = status,
                Appointment_date_time__c = appointmentTime
            );
            insert newCase;
            return newCase;
        } catch (Exception e) {
            System.debug('Error while saving the case: ' + e.getMessage());
        }
        return null;
    }

}