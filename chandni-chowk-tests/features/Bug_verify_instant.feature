Feature: BugVerification
1.AIB-908

Scenario: get-valid-channels
Given I want to run DSP APIs
When I run "create-user" API with "complete" data
When I run "get-campaign-name" with "Valid" user_token
When I run "is-valid-campaign-name" with "Valid" campaign_name
When I run "save-campaign" API with "Valid" campaign_id

#When I run "get-users-campaign-list" with "Valid" user_token
