public without sharing class sSupplierCustom extends sObjectAbstract {

    private String getsObjectTypeAPIName() {
        return 'Supplier__c';
    }

    private List<String> getBaseFields() {
        return new List<String>{
            'Id', 
            'Name', 
            'City__c', 
            'Billing_Address__Street__s',
            'Location__Latitude__s', 
            'Location__Longitude__s'  
        };
    }

    public List<Supplier__c> getSearchRecords(String city, String sortByDistance) {

        this.queryWhereConditions = ' ' + city;
        this.queryPostConditions += ' ORDER BY ' + sortByDistance;

        return queryData();
    }


    public List<Supplier__c> getRecordById(Id recordId) {
        if(String.isBlank(recordId)){
            return new List<Supplier__c>();
        }
        return this.getRecordsByIds(new List<Id>{recordId}) ;
    }

    public List<Supplier__c> getRecordsByIds(List<Id> recordIds) {
        this.queryWhereConditions = this.createInCondition('Id', recordIds);
        return this.queryData();
    }

}