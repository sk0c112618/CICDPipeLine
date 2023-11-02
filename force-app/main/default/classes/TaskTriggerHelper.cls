public class TaskTriggerHelper {
    public static void beforedelete(List<Task> taskList){
      	List<Profile> profileList = [Select id from profile where name = 'System Administrator'];
        for (Task taskObj: taskList){
            If(userInfo.getProfileId() != profileList[0].Id){
                taskObj.addError('PLease contact System Admin to Delete this Task');
            }
        }
        
    }
}