public with sharing class sObjectAnalyser {
    private sObjectAnalyser() {
    }
    private static sObjectAnalyser sObjectAnalyser = NULL;
    private Map<String, List<sObjectQueryAnalyser>> queryMap = new Map<String, List<sObjectQueryAnalyser>>();

    public static sObjectAnalyser getInstance() {
        if (sObjectAnalyser == NULL) {
            sObjectAnalyser = new sObjectAnalyser();
        }
        return sObjectAnalyser;
    }

    public void saveQueryResult(String objectType, String soqlString, String soqlWhere, String soqlPost, Map<Id, sObject> queryResult) {
        List<sObjectQueryAnalyser> tempList = new List<sObjectQueryAnalyser>();
        if (queryMap.containsKey(objectType)) {
            tempList = queryMap.get(objectType);
        }
        tempList.add(new sObjectQueryAnalyser(tempList.size(), objectType, soqlString, soqlWhere, soqlPost, queryResult));
        queryMap.put(objectType, tempList);
    }

    public List<sObjectQueryAnalyser> getQueryAnalysersByType(String objectType){
        if(queryMap.containsKey(objectType)){
            return queryMap.get(objectType);
        }
        return new List<sObjectQueryAnalyser>();
    }

    public List<sObject> getCachedResults(String objectType, String soqlSting){
        for(sObjectQueryAnalyser item:getQueryAnalysersByType(objectType)){
            if(item.soqlString.equalsIgnoreCase(soqlSting)){
                return item.queryResult.values();
            }
        }
        return new List<sObject>();
    }

    public Map<Id, sObject> getCachedRecordsByType(String objectType){
        Map<Id, sObject> result = new Map<Id, sObject>();
        for(sObjectQueryAnalyser item:getQueryAnalysersByType(objectType)){
            result.putAll(item.queryResult.values());
        }
        return result;
    }
}