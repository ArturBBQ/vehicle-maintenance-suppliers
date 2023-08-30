public without sharing class CaseTriggerHandler implements ITriggerHandler {
    
    private Boolean triggerIsExecuting;
    private Integer triggerSize;
    public CaseTriggerHelper helper;
    public CaseTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new CaseTriggerHelper();
    }

    /* ========== TRIGGER METHODS ========== */ 

    public void beforeInsert(List<Case> newItems) {}
    public void beforeUpdate(List<Case> oldItems, List<Case> newItems, Map<ID, SObject> oldItemsMap, Map<ID, SObject> newItemsMap) {}
    public void beforeDelete(List<Case> oldItems, Map<ID, SObject> oldItemsMap) {}
    public void afterInsert(List<Case> newItems, Map<ID, SObject> newItemsMap) {}

    public void afterUpdate(List<Case> oldItems, List<Case> newItems, Map<ID, SObject> oldItemsMap, Map<ID, SObject> newItemsMap) {
        helper.countAverageAccountRating(newItems);
    }

    public void afterDelete(List<Case> oldItems, Map<ID, SObject> oldItemsMap) {}
    public void afterUndelete(List<Case> newItems, Map<ID, SObject> newItemsMap) {}

}