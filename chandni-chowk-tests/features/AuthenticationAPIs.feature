Feature:  Testing the Authentication APIs for DSP
          1. Create user
	  2. Login
	  3. Edit-user
	  4. Change password
	  5. Forgot password API
	  6. Is valid 
	  7. Change forgot password
	  8. Create guest user
	  9. 
##Create User API
#Scenario: Create User API functionality for valid complete data and valid mandatory data
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#Then I should see "Account created successfully" message
#When I run "create-user" API with "mandatory" data
#Then I should see "Account created successfully" message

#
#Scenario: Create User API functionality for repetitive, invalid and missing data
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#Then I should see "Account created successfully" message
#When I run "create-user" with "existing-email"
#Then I should see "User already exists with this email" exist message
##email with double dot
#When I run "create-user" with "invalid-email-dd"
#Then I should see "Input validation failed" error message
##email without @
#When I run "create-user" with "invalid-email-@"
#Then I should see "Input validation failed" error message
##email without .
#When I run "create-user" with "invalid-email-."
#Then I should see "Input validation failed" error message
##email with white spaces
#When I run "create-user" with "white-spaces"
#Then I should see "Input validation failed" error message
#When I run "create-user" with "missing-email"
#Then I should see "Input validation failed" error message
#When I run "create-user" with "missing-password"
#Then I should see "Password cannot be empty" missing message
##phone num with characters
#When I run "create-user" with "invalid-phone-chars"
#Then I should see "Input validation failed" error message
##phone num with more than 11 digits
#When I run "create-user" with "invalid-phone>dig"
#Then I should see "Input validation failed" error message
##phone num with less than 10 digits
#When I run "create-user" with "invalid-phone<dig"
#Then I should see "Input validation failed" error message
#When I run "create-user" with "missing-phone"
#Then I should see "Input validation failed" error message
#When I run "create-user" with "missing-name"
#Then I should see "Input validation failed" error message
#When I run "create-user" with "missing-company_name"
#Then I should see "Input validation failed" error message

#Scenario: Validate the response/content/data/permissions of Create-user API with mysql db
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#Then I should see "valid_data" stored in mysql for "create-user" API
#Then I should see valid permissions for "create-user" user from mysql db


##Login API
#Scenario: Login using valid Email id and Password
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#Then I should see "Account created successfully" message
#When I run "login" API with "Valid_id" Email and "Valid" Password
#Then I should see "Login successfull" message
#When I run "login" API with "Invalid_id" Email and "Valid" Password
#Then I should see "User does not exist" message
#When I run "login" API with "Valid_id" Email and "Invalid" Password
#Then I should see "Wrong password" message
#When I run "login" API with "Empty" Email and "Empty" Password
#Then I should see "Email or password empty" message

#Scenario: Login using valid Email id and Password & validate response
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#Then I should see valid permissions for "create-user" user from mysql db
#When I run "login" API with "Valid_id" Email and "Valid" Password
#Then I should see "valid_data" stored in mysql for "login" API
#Then I should see valid permissions for "login" user from mysql db

##Edit user API
#Scenario: Editing user with Valid/Invalid/Missing details using Valid/Invalid user token
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#Then I should see "valid_data" stored in mysql for "create-user" API
#When I run "edit-user" API with "Valid" details using "Valid" user token
#Then I should see "Saved successfully" message 
#Then I should see "valid_data" stored in mysql for "edit-user" API
#When I run "edit-user" API with "missing" details using "Valid" user token
#Then I should see "Saved successfully" message
#When I run "edit-user" API with "Valid" details using "Valid" user token
#Then I should see "valid_data" stored in mysql for "edit-user" API
#When I run "edit-user" API with "Invalid" details using "Valid" user token
#Then I should see "valid_data" stored in mysql for "edit-user" API
#When I run "edit-user" API with "Invalid" details using "Invalid" user token
#Then I should see "Invalid token" message

##Change Password API
#Scenario:Checking the Change password API for existing/non existing email id giving old/invalid password  & valid/invalid new password
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#When I run "change-password" API for "Valid" email and "Valid" old password and "Valid" new password
#Then I should see "Change Password Successfull" message
###This below scenario should not pass
#When I run "change-password" API for "Valid" email and "Valid" old password and "Invalid" new password
#Then I should see "Change Password Successfull" message
#When I run "change-password" API for "Valid" email and "Invalid" old password and "Valid" new password
#Then I should see "Wrong password" message
#When I run "change-password" API for "Invalid" email and "Valid" old password and "Valid" new password
#Then I should see "User does not exist" message

##Forgot password API
#Scenario: Checking the Forgot Password API for existing/non existing email id 
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#here valid email id means Existing email id
#When I run "forgot-password" API for "Valid" email
#Then I should see "Mail sent" message
#Here Invalid email id means Non existing email id
#When I run "forgot-password" API for "Invalid" email
#Then I should see "User does not exist" message

##Is valid
#Scenario: Checking is-valid-forgot-password-token API for valid and invalid token
#Given I want to run Authentication APIs
#When I run "create-user" API with "complete" data
#When I run "is-valid-forgot-password-token" with "Valid" user token
#Then I should see "Valid token" message
#When I run "is-valid-forgot-password-token" with "Invalid" user token
#Then I should see "Invalid token" message

##Change forgot password API
#Scenario: Checking change-forgot-password API for valid user token and valid new password
#When I run "create-user" API with "complete" data
#When I run "change-forgot-password" API with "Valid" user token and "Valid" new password
#Then I should see "Password changed" message
#When I run "login" API with "Valid_id" Email and "New" Password
#Then I should see "Login successfull" message
#When I run "login" API with "Valid_id" Email and "Old" Password
#Then I should see "Wrong password" message
#When I run "change-forgot-password" API with "Valid" user token and "Invalid" new password
##Below case should pass to fail
#Then I should see "Password changed" message
#When I run "change-forgot-password" API with "Invalid" user token and "Valid" new password
#Then I should see "Invalid token" message


##Create guest user API & Register guest user & login guest user
Scenario: Checking create-guest-user API 
When I run "create-guest-user" API
Then I should see "Account created successfully" message
Then I should see "valid_data" stored in mysql for "create-guest-user" API
#Then I should see valid permissions for "create-guest-user" user from mysql db
#When I run "register-guest-user" API with "Valid" user_token and "Valid" details
#Then
#When I run "register-guest-user" API with "Invalid" user_token and "Valid" details
#Then
#When I run "register-guest-user" API with "Valid" user_token and "Invalid" details
#Then
#When I run "register-guest-user" API with "Invalid" user_token and "Invalid" details
#Then
#When I run "login-guest-user" with "Valid" details
#Then
#When I run "login-guest-user" with "Invalid" details
#Then

#Scenario: Register guest user with already existing user



