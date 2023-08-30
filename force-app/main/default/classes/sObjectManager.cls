public with sharing class sObjectManager {

    private static Map<String, sObjectAbstract> sObjectUtilMap = new Map<String, sObjectAbstract>();

    private static boolean isManagerExist(String className){
        return sObjectUtilMap.containsKey(className);
    }

    private static string getClassName(String sObjectName){
        sObjectName = 's'+sObjectName;
        if(sObjectName.endsWithIgnoreCase('__c')){
            sObjectName = sObjectName.removeEndIgnoreCase('__c')+'Custom';
        }else if(sObjectName.endsWithIgnoreCase('__mdt')){
            sObjectName = sObjectName.removeEndIgnoreCase('__mdt')+'CustomMetaData';
        }
        return sObjectName;
    }

    public static void setObjectManager(String sObjectName, sObjectAbstract classInstance){
        String className = getClassName(sObjectName);
        if(sObjectManager.isManagerExist(className)){
            //Move errors to the CustomLabels
            throw new sObjectAbstractException('Object Manager for '+sObjectName+' already exist.');
        }else{
            sObjectUtilMap.put(className, classInstance);
        }
    }

    public static sObjectAbstract getObjectManager(String sObjectName){
        String className = getClassName(sObjectName);
        if(isManagerExist(className)){
            return sObjectUtilMap.get(className);
        }else{
            Type classType = Type.forName(className);
            if(classType != NULL){
                sObjectUtilMap.put(className, (sObjectAbstract) classType.newInstance());
                return sObjectUtilMap.get(className);
            }
        }
        return NULL;
    }
}