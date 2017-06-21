Feature: Get APIs(ListData) for DSP
	1. get-languages
	2. get-campaign-objectives
	3. get-product-category
	4. get-audience-type
	5. get-product-sub-category
	6. get-age
	7. get-regions
	8. get-amagi-work (view our work)
        9. get-country-state-mappings
       10. get-org-types
       11. get-industry-types

Scenario: Checking if get-languages API gives correct reponse
#Initially for the first GET API, we check whether the DSP is running successfully
Given I want to run DSP APIs
When I run GET for "get-languages" API for the field "language"
Then I should see correct entries from table "channel_mappings" for field "language"

Scenario: Checking if get-campaign-objectives API gives correct response
Given I want to run GET APIs
When I run GET for "get-campaign-objectives" API for the field "campaign_objectives"
Then I should see correct entries from table "campaign_objectives" for field "campaign_objectives"


Scenario: Checking if get-product-category API gives correct response
Given I want to run GET APIs
When I run GET for "get-product-category" API for the field "product_category"
Then I should see correct entries from table "product_category" for field "product_category"

Scenario: Checking if get-audience-type API gives correct response
Given I want to run GET APIs
When I run GET for "get-audience-type" API for the field "audience_type"
Then I should see correct entries from table "profile_to_tg" for field "audience_type"

Scenario: Checking if get-product-sub-category API gives correct response
Given I want to run GET APIs
When I run GET for "get-product-sub-category" API for the field "product_sub_category"
Then I should see correct entries from table "product_sub_category" for field "product_sub_category"

Scenario: Checking if get-age API gives correct response
Given I want to run GET APIs
When I run GET for "get-age" API for the field "age"
Then I should see correct entries from table "channel_reach" for field "age"

Scenario: Checking if get-regions API gives correct response
Given I want to run GET APIs
When I run GET for "get-regions" API 
Then I should see correct entries from table "regions"


Scenario: Checking if get-country-state-mappings API gives correct response
Given I want to run GET APIs
When I run GET for "get-country-state-mappings" API 
Then I should see correct entries from table "country_state_mappings"

Scenario: Checking if get-org-types API gives correct response
Given I want to run GET APIs
When I run GET for "get-org-types" API for the field "organization_type"
Then I should see correct entries from table "organization_types" for field "organization_type"

Scenario: Checking if get-industry-types API gives correct response
Given I want to run GET APIs
When I run GET for "get-industry-types" API for the field "industry_type"
Then I should see correct entries from table "industry_types" for field "industry_type"




Scenario: Checking if adding and deleting new data in get-languages gives correct reponse
Given I want to run GET APIs
When I update "channel_mappings" table with "language" entry
Then I should see correct and updated response in "get-languages" API for the field "language"  
When I delete an entry from "channel_mappings" table for the field "language"
Then I should see the correct and modified response in "get-languages" API for the field "language"

Scenario: Checking if adding and deleting new data in get-campaign-objectives gives correct reponse
Given I want to run GET APIs
When I update "campaign_objectives" table with "campaign_objectives" entry
Then I should see correct and updated response in "get-campaign-objectives" API for the field "campaign_objectives"
When I delete an entry from "campaign_objectives" table for the field "campaign_objectives"
Then I should see the correct and modified response in "get-campaign-objectives" API for the field "campaign_objectives"

Scenario: Checking if adding and deleting new data in get-product-category gives correct reponse
Given I want to run GET APIs
When I update "product_category" table with "product_category" entry
Then I should see correct and updated response in "get-product-category" API for the field "product_category"
When I delete an entry from "product_category" table for the field "product_category"
Then I should see the correct and modified response in "get-product-category" API for the field "product_category"

Scenario: Checking if adding and deleting new data in get-audience-type gives correct reponse
Given I want to run GET APIs
When I update "profile_to_tg" table with "audience_type" entry
Then I should see correct and updated response in "get-audience-type" API for the field "audience_type"
When I delete an entry from "profile_to_tg" table for the field "audience_type"
Then I should see the correct and modified response in "get-audience-type" API for the field "audience_type"

Scenario: Checking if adding and deleting new data in get-product-sub-category gives correct reponse
Given I want to run GET APIs
When I update "product_sub_category" table with "product_sub_category" entry
Then I should see correct and updated response in "get-product-sub-category" API for the field "product_sub_category"
When I delete an entry from "product_sub_category" table for the field "product_sub_category"
Then I should see the correct and modified response in "get-product-sub-category" API for the field "product_sub_category"

Scenario: Checking if adding and deleting new data in get-age gives correct reponse
Given I want to run GET APIs
When I update "channel_reach" table with "age" entry
Then I should see correct and updated response in "get-age" API for the field "age"
When I delete an entry from "channel_reach" table for the field "age"
Then I should see the correct and modified response in "get-age" API for the field "age"

Scenario: Checking if adding and deleting new data in get-org-types gives correct reponse
Given I want to run GET APIs
When I update "organization_types" table with "organization_type" entry
Then I should see correct and updated response in "get-org-types" API for the field "organization_type"
When I delete an entry from "organization_types" table for the field "organization_type"
Then I should see the correct and modified response in "get-product-sub-category" API for the field "organization_type"

Scenario: Checking if adding and deleting new data in get-industry-types gives correct reponse
Given I want to run GET APIs
When I update "industry_types" table with "industry_type" entry
Then I should see correct and updated response in "get-industry-types" API for the field "industry_type"
When I delete an entry from "industry_types" table for the field "industry_type"
Then I should see the correct and modified response in "get-industry-types" API for the field "industry_type"

Scenario: Checking if adding and deleting new data in get-country-state-mappings gives correct reponse
Given I want to run GET APIs
When I update "country_state_mappings" table with "state" entry
Then I should see correct and updated response in "get-country-state-mappings" API for the field "state"
When I delete an entry from "country_state_mappings" table for the field "state"
Then I should see the correct and modified response in "get-country-state-mappings" API for the field "state"

Scenario: Checking if adding and deleting new data in get-regions gives correct reponse
Given I want to run GET APIs
When I update "regions" table with "region" entry
Then I should see correct and updated response in "get-regions" API for the field "region"
When I delete an entry from "regions" table for the field "region"
Then I should see the correct and modified response in "get-regions" API for the field "region"


Scenario: Checking the Successfulness of APIs
Given I want to run GET APIs
When I run LISTDATA APIs
Then I should see Request completed successfully message and error should be nil for "get-languages" API
Then I should see Request completed successfully message and error should be nil for "get-campaign-objectives" API
Then I should see Request completed successfully message and error should be nil for "get-product-category" API
Then I should see Request completed successfully message and error should be nil for "get-audience-type" API
Then I should see Request completed successfully message and error should be nil for "get-product-sub-category" API
Then I should see Request completed successfully message and error should be nil for "get-age" API
Then I should see Request completed successfully message and error should be nil for "get-regions" API
Then I should see Request completed successfully message and error should be nil for "get-country-state-mappings" API
Then I should see Request completed successfully message and error should be nil for "get-org-types" API
Then I should see Request completed successfully message and error should be nil for "get-industry-types" API
