global with sharing class ConvertAutomationToDeployment {
    /**
     * Custom object for storing InvocableVariables. InvocableMethods requires List<T> where T is a user defined type.
     * You cannot pass Boolean, String or any other primitive type as a variable to an Invocable method.
     * Custom Object types, sObjects or Ids are the only supported types.
     * @see InvocableVariable
     * @see InvocableMethod
     */
    global class InvocableVariables {
        @InvocableVariable(label='Automation Template Id' required=true)
        global Id automationTemplateId;
        // use String for optional parameters, otherwise cast to Id could fail if the flow returns a null value
        @InvocableVariable(label='Source Credential Id' required=false)
        global String sourceCredentialId;
        // use String for optional parameters, otherwise cast to Id could fail if the flow returns a null value
        @InvocableVariable(label='Target Credential Id' required=false)
        global String targetCredentialId;
        @InvocableVariable(label='Execute Automatically' required=false)
        global Boolean execute;
    }

    /**
     * Invocable method for allowing users to execute an automation template from Process builder/flow.
     * @param  requests parameters from flow
     * @return          execution result
     * @see InvocableVariable
     * @see InvocableMethod
     */
    @InvocableMethod(label='Execute Automation Template' description='Convert Automation into a deployment, clone the steps, create destination orgs and clone attachments')
    global static List<Result__c> execute(List<InvocableVariables> requests) {
        Id automationTemplateId = requests[0].automationTemplateId;
        Id sourceCredentialId = String.isNotBlank(requests[0].sourceCredentialId) ? requests[0].sourceCredentialId : null;
        Id targetCredentialId = String.isNotBlank(requests[0].targetCredentialId) ? requests[0].targetCredentialId : null;
        Boolean execute = requests[0].execute;
        return AutomationTemplateExecuter.execute(automationTemplateId, sourceCredentialId, targetCredentialId, execute);
    }
}