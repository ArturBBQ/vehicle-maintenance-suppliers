public abstract class sObjectAbstract {

    public sObjectAbstract(){
       sObjectManager.setObjectManager(getsObjectTypeAPIName(), this);
    }

    protected String createInCondition(String fieldName, List<String> soqlValues, Boolean isIN){
        List<String> safeList = new List<String>();
        for(String item:soqlValues){
            safeList.add(String.escapeSingleQuotes(item));
        }
        String soqlListString = '\'' + String.join(safeList, '\',\'') + '\'';
        return ' '+fieldName+' '+(isIN ? 'IN' : 'NOT IN')+' (' + soqlListString + ')';
    }

    protected String createInCondition(String fieldName, List<String> soqlValues){
        return createInCondition(fieldName, soqlValues, true);
    }

    private Integer queryCount = 0;
    public Boolean skipBaseField = false;
    public Boolean skipCache = false;
    public Boolean skipCacheOnce = false;

    private String sObjectQuery;

    protected String queryWhereConditions{
        get{
            if(String.isBlank(queryWhereConditions)){
                queryWhereConditions = '';
            }
            return queryWhereConditions;
        }
        set;
    }

    protected String queryPostConditions{get{
        if(String.isBlank(queryPostConditions)){
            queryPostConditions = '';
        }
        return queryPostConditions;
    }
        set;
    }

    protected List<String> additionalFields{get{
        if(additionalFields == NULL){
            additionalFields = new List<String>();
        }
        return additionalFields;
    }
        set;
    }

    abstract String getsObjectTypeAPIName();

    @testVisible
    abstract List<String> getBaseFields();

    protected  List<sObject> queryData(){
        sObjectAnalyser analyserInst = sObjectAnalyser.getInstance();

        List<String> finalFields = new List<String>();
        if(!skipBaseField){
            finalFields.addAll(this.getBaseFields());
        }
        finalFields.addAll(this.additionalFields);

        String finalWhereConditions = '';
        sObjectQuery = 'SELECT ';


        if(String.isNotBlank(queryWhereConditions)){
            finalWhereConditions += this.queryWhereConditions;
        }


        for(String field:finalFields){
            sObjectQuery += field+',';
        }

        sObjectQuery = sObjectQuery.substring(0, sObjectQuery.length()-1);
        sObjectQuery += ' FROM '+this.getsObjectTypeAPIName();

        if(String.isNotBlank(finalWhereConditions)){
            sObjectQuery += ' WHERE '+finalWhereConditions;
        }
        if(String.isNotBlank(queryPostConditions)){
            sObjectQuery += ' '+queryPostConditions;
        }

        List<sObject> queryResult = new List<sObject>();
        //You can analise your query before making it and return cached results.
        if(!skipCache && !skipCacheOnce){
            queryResult = analyserInst.getCachedResults(getsObjectTypeAPIName(), sObjectQuery);
        }
        if(queryResult.isEmpty()){
            queryCount++;
            queryResult = database.query(sObjectQuery);
        }
        skipCacheOnce = false;

        //You can make a post analise of results in order to find risky processes.
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        for (sObject item : queryResult) {
            objectMap.put((Id)item.get('Id'), item);
        }

        if (!skipBaseField) {
            analyserInst.saveQueryResult(getsObjectTypeAPIName(), sObjectQuery, queryWhereConditions, queryPostConditions, objectMap);
        }

        return queryResult;
    }
}