public with sharing class CTLocationUpdateStatusSchedule implements Schedulable{
    public static final String CRON='0 0 2 * * ? ';
    public void execute(SchedulableContext sc){
        CTLocationUpdateStatusBatch BatchInstance = new CTLocationUpdateStatusBatch();
        // calling with a batch size 50
        Database.executeBatch(BatchInstance, 2000);
    }
}