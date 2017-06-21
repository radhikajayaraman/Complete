Feature: Testing the Billing APIs:
        1. Get billing info
	2. Save billing info
	3. Update billing info
        4. Delete billing info
       
        

#Scenario: Calling get-billing-informations API for valid user with valid user_token
#Given I want to run Billing APIs
#When I run "create-user" API with "complete" data 
#When I run "get-billing-informations" API with "Valid" user_token
#Then I should see "billing information retrived successfully" message
#When I run "get-billing-informations" API with "Invalid" user_token
#Then I should see "Invalid token" message

Scenario: Calling save-billing-information API with Valid details
Given I want to run Billing APIs
When I run "create-user" API with "complete" data
When I run "save-billing-information" API with "Valid" details

#Scenario: Calling save-billing-information API with Invalid details
