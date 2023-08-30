/**
 * Class containing methods for LWC: 
 * accontSuppliers(getSuppliersByCity method) 
 * and bookAppointmentModal(bookAppointment method)
 */

public with sharing class AccountSuppliersController {

    /**
     * This method getSuppliersByCity retrieves a list of suppliers based on 
     * the specified city and geographical coordinates.
     * A list of Supplier__c records that match the specified city and are sorted by distance from the provided Account coordinates.
     */
    @AuraEnabled
    public static List<Supplier__c> getSuppliersByCity(String accountCity, Double accountLatitude, Double accountLongitude) {
        
        sSupplierCustom suppliersUtil = (sSupplierCustom) sObjectManager.getObjectManager('Supplier__c');
        String filterCity = 'City__c = \'' + accountCity + '\'';
        String sortBy = 'DISTANCE(Location__c, GEOLOCATION(' + accountLatitude + ' , ' + accountLongitude + '), \'km\')';
        List<Supplier__c> suppliers = suppliersUtil.getSearchRecords(filterCity, sortBy);
        
        return suppliers;
    } 

    /**
     * This method books an appointment by creating a new Case record with the provided information.
     * return The newly created Case record representing the booked appointment,
     * or AuraHandledException if an error occurs while saving the Case, containing an error message.
     */
    @AuraEnabled
    public static Case bookAppointment(String contactId, String accountId, String supplierId, 
                                       String status, String caseOrigin, Datetime appointmentTime) {
        try {
            Case newCase = new Case(
                ContactId = contactId,
                AccountId = accountId,
                Supplier__c = supplierId,
                Origin = caseOrigin,
                Status = status,
                Appointment_date_time__c = appointmentTime
            );
            insert newCase;
            return newCase;
        } catch (Exception e) {
            //labels - 'Error while saving the case: '
            String errorMessage = 'Error while saving the case: ' + e.getMessage();
            // Throw a custom exception to return the error message to the UI
            throw new AuraHandledException(errorMessage);
        }
    }

}