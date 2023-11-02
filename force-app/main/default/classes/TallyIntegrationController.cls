@RestResource(urlMapping='/tally/*')
global with sharing class TallyIntegrationController {

    @HttpPost
    global static String receiveData(String jsonData) {
        // Process the incoming JSON data from Tally ERP 9
        // You can parse the jsonData, create records, or perform any required actions here
        System.debug('Received Data: ' + jsonData);

        // Return a response if needed
        return 'Data received successfully';
    }
}