public with sharing class CTLocationDataCleanupSchedule implements Schedulable{
    public static final String CRON='0 0 2 * * ? ';
    public void execute(SchedulableContext sc){
        CTLocationTracingDataCleanupBatch BatchInstance = new CTLocationTracingDataCleanupBatch();
        // calling with a batch size 50
        Database.executeBatch(BatchInstance, 2000);
    }
}



