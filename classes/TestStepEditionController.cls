@IsTest
private class TestStepEditionController {
    @IsTest
    static void myUnitTest() {
        StepEditionController handler = new StepEditionController();

        Step__c testStep = new Step__c();
        testStep.Name = 'test';

        handler.setStep(testStep);

        System.assertEquals(true, handler.filtered);

        Step__c currentStep = handler.getStep();

        System.assertEquals(testStep, currentStep);
    }
}