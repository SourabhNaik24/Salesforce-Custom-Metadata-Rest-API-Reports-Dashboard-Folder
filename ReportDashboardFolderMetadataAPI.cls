/*-------------------------------------------------------------------------------------------
Name:       ReportDashboardFolderMetadataAPI.cls
Purpose:    An Apex Class for Metadata REST API Service to get Reports/Dashboards Folders details
------------------------------History--------------------------------------------------------
Version     Author                Date                 Detail Description 
-------     ---------------       --------------       ------------------
1.0         Sourabh Naik          22nd Dec 2024        Initial Development 
--------------------------------------------------------------------------------------------*/
public class ReportDashboardFolderMetadataAPI {
    /*
     * Method Name : getFolderMetadata
     * Return Type : String
     * Parameters : String of Folder's Id
     * Description : Method to get Folder's Metadata details like Shared to etc.
     * */
    public String getFolderMetadata(String folderId) {
        String baseUrl = Url.getOrgDomainUrl().toExternalForm();
        String endpoint = baseUrl + '/services/data/v41.0/folders/' + folderId + '/shares';
        
        // Create an HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        
        // Create an HTTP object
        Http http = new Http();
        
        // Send the request and get the response
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Parse the metadata response
            String responseBody = res.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> records = (List<Object>) responseMap.get('shares');
            for (Object record : records) {
                Map<String, Object> recordMap = (Map<String, Object>) record;
                String sharedWithLabel = (String) recordMap.get('sharedWithLabel');
                String shareType = (String) recordMap.get('shareType');
                String shareId = (String) recordMap.get('shareId');
                String accessType = (String) recordMap.get('accessType');
                
                System.debug('User/Role Name: ' + sharedWithLabel + ', Share Type: ' + shareType + 'Share Id: ' + shareId + ', Access Type: ' + accessType);
            }
            // Process the metadata as needed
            return responseBody;
        } else {
            // Handle errors
            return 'Error: ' + res.getStatusCode() + ' - ' + res.getStatus();
        }
    }
}