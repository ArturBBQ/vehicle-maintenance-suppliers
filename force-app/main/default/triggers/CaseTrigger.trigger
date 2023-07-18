trigger CaseTrigger on Case (after insert, after update) {

    if(Trigger.isAfter) {

        if(Trigger.isUpdate || Trigger.isInsert) {
            CaseTriggerHandler.countAverageAccountRating(Trigger.new);
        }
    }

}