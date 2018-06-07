/*******************************************************************************************************
* @descripton Representation of a TreeDiagram Node in the Trigger Dashboard.
* @Author: Kofi Johnson - https://github.com/kofijohnson
********************************************************************************************************/

public class TriggerDashboardNode extends TreeDiagramNode {
    private Map<String, GovernorLimit> governorLimits;

    private static final String SOQL_GOVERNOR = 'SOQL_QUERIES';
    private static final String DML_GOVERNOR = 'DML_STATEMENTS';

    /*******************************************************************************************************
    * @description TriggerDashboardNode Constructor
    ********************************************************************************************************/
    public TriggerDashboardNode(String name) {
        super(name);

        this.setColor('white');
        governorLimits = new Map<String, GovernorLimit> {
            SOQL_GOVERNOR => new GovernorLimit('SOQL Queries', Limits.getLimitQueries()),
            DML_GOVERNOR => new GovernorLimit('DML Statements', Limits.getLimitDMLStatements())
        };
        governorLimits.get(SOQL_GOVERNOR).startLimit = Limits.getQueries();
        governorLimits.get(DML_GOVERNOR).startLimit = Limits.getDMLStatements();
    }

    /*******************************************************************************************************
    * @description Sets the Component Type (Trigger, MicroTrigger or Action).
    * @param String The Component Type.
    * @return TriggerDashboardNode.
    ********************************************************************************************************/
    public TriggerDashboardNode setComponentType(String componentType) {
        this.setToolTipTitle(componentType + ': ' + this.getName());

        if (componentType.equalsIgnoreCase('Action')) {
            this.setColor('red');
        }
        if (componentType.equalsIgnoreCase('MicroTrigger')) {
            this.setColor('green');
        }
        if (componentType.equalsIgnoreCase('Trigger')) {
            this.setColor('blue');
        }

        return this;
    }

    /*******************************************************************************************************
    * @description Captures the current Limits.
    * @return void.
    ********************************************************************************************************/
    public void captureUsages() {
        governorLimits.get(SOQL_GOVERNOR).endLimit = Limits.getQueries();
        governorLimits.get(DML_GOVERNOR).endLimit = Limits.getDMLStatements();

        List<String> result = new List<String>();
        String usageLineFormat = '<strong>{0}:</strong> {1} → {2} ({3})';
        for (GovernorLimit currentGovernorLimit : governorLimits.values()) {
            result.add(
                String.format(usageLineFormat, new List<String>{
                    currentGovernorLimit.name,
                    String.valueOf(currentGovernorLimit.startLimit),
                    String.valueOf(currentGovernorLimit.endLimit),
                    String.valueOf(currentGovernorLimit.getUsage())
                })
            );
        }
        
        this.addToolTipDetails(String.join(result, '<br>'));
    }

    /*******************************************************************************************************
    * @description Validates if the current usages exceed the defined treshold. Creates a Notification.
    * @return void.
    ********************************************************************************************************/
    public void validateUsages() {
        MicroTriggerNotificationSettings__c notificationSettings = MicroTriggerNotificationSettings__c.getOrgDefaults();
        if (notificationSettings == null)
            return;
            
        governorLimits.get(SOQL_GOVERNOR).endLimit = Limits.getQueries();
        governorLimits.get(DML_GOVERNOR).endLimit = Limits.getDMLStatements();

        if (
            (notificationSettings.SOQLQueries__c != null && governorLimits.get(SOQL_GOVERNOR).exceedUsage(notificationSettings.SOQLQueries__c)) ||
            (notificationSettings.DMLStatements__c != null && governorLimits.get(SOQL_GOVERNOR).exceedUsage(notificationSettings.DMLStatements__c))
        ) {
            insert new MicroTriggerNotification__c(
                SOQLQueries__c = String.valueOf(governorLimits.get(SOQL_GOVERNOR).endLimit),
                DMLStatements__c = String.valueOf(governorLimits.get(DML_GOVERNOR).endLimit),
                Log__c = JSON.serialize(this)
            );
        }
    }

    
    /*******************************************************************************************************
    * @descripton Governor Limit Wrapper.
    ********************************************************************************************************/
    class GovernorLimit {
        private String name;
        private Integer totalLimit;

        public Integer startLimit {get; set;}
        public Integer endLimit {get; set;}

        public GovernorLimit(String name, Integer totalLimit) {
            this.name = name;
            this.totalLimit = totalLimit;
        }

        public Integer getUsage() {
            return endLimit - startLimit;
        }

        public Boolean exceedUsage(Decimal percent) {
            return ((getUsage() * 100) / totalLimit) >= percent;
        }
    }
}