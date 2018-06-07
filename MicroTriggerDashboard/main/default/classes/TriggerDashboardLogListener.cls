/*******************************************************************************************************
* @Description: MicroTrigger Dashboard Class.
* @Author: Kofi Johnson - https://github.com/kofijohnson
********************************************************************************************************/

public class TriggerDashboardLogListener implements MicroTriggerLogging.LogListener {
    private static final String START_LOG_NAME = 'START';
    private static TriggerDashboardNode startNode = new TriggerDashboardNode(START_LOG_NAME);
    private static TriggerDashboardNode currentNode;

    /*******************************************************************************************************
    * @description Runs when a new Log starts.
    * @param LogEvent Contains the information about the Log.
    * @return void.
    ********************************************************************************************************/
    public void logStarted(MicroTriggerLogging.LogEvent logEvent) {
        if(currentNode == null) {
            currentNode = startNode;
        }

        TriggerDashboardNode newNode = new TriggerDashboardNode(logEvent.componentName);
        newNode.setComponentType(logEvent.componentType);

        currentNode.addChild(newNode);
        currentNode = newNode;
    }

    /*******************************************************************************************************
    * @description Runs when a new Log completes.
    * @param LogEvent Contains the information about the Log.
    * @return void.
    ********************************************************************************************************/
    public void logCompleted(MicroTriggerLogging.LogEvent logEvent) {
        currentNode.captureUsages();
        currentNode = (TriggerDashboardNode) currentNode.getParent();

        if(currentNode.getName() == START_LOG_NAME && currentNode.children() == 2) {
            currentNode.captureUsages();
            currentNode.validateUsages();
            currentNode.display();
        }
    }
}