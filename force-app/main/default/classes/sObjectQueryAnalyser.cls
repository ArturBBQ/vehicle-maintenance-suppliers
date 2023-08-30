public with sharing class sObjectQueryAnalyser {
    public Integer queryNumber;
    public String objectType;
    public String soqlString;
    public String soqlWhere;
    public String soqlPost;
    public Map<Id, sObject> queryResult;
    public sObjectQueryAnalyser(Integer queryNumber, String objectType, String soqlString, String soqlWhere, String soqlPost, Map<Id, sObject> queryResult) {
        this.queryNumber = queryNumber;
        this.objectType = objectType;
        this.soqlString = soqlString;
        this.soqlWhere = soqlWhere;
        this.soqlPost = soqlPost;
        this.queryResult = queryResult;
    }

}