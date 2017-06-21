require 'net/http'
require 'mysql'
require 'faker'
require 'test/unit'
require 'test/unit/assertions'
require 'json'
require 'net/http'
require 'httparty'
require 'unirest'
include Test::Unit::Assertions
require 'dbi'
#Initializing set of global variables
def input
$name = Faker::Name.name
$email = Faker::Internet.free_email
$password = Faker::Internet.password
$company_name = Faker::Company.name
$phone = Faker::Number.number(10)
$c_list = ["Listed","Partnership","Private","Proprietorship"]
$company_type = $c_list[rand($c_list.length)]
$u_list = ["low-income","high-income"]
$user_type = $u_list[rand($u_list.length)]
#$pan_number = Faker::Base.regexify("/[A-Z]{5}[0-9]{4}[A-Z]{1}/")
$pan_number = Faker::Base.regexify("/[ABCFGHLJPT]{5}[0-9]{4}[ABCFGHLJPT]{1}/")
$i_list = ["Apparels","Garments","Advertising"]
$industry_type = $i_list[rand($i_list.length)]
$timedout_user_token = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0NjQ2ODY0NzEsImlhdCI6MTQ2NDA4MTY3MSwic3ViIjoiMWJmYWRkN2MtZWFlOS00M2FkLWIzNmYtMjk0MmY0NDQzYjM4In0.TxxjfPW3KIMyUD7-Hv1NcrJ2CpPiOBq1Qp09G9uoNQwuI4oto6X0Kbpwx6T7t3Dgo8ZOGtOP_Vy_wghi4xhEnTEkfMtrtVrlt1avVuisGrMDZyCVpwJ5ZGClOIb4y7X_azeRv10RrDmaWG4duXyikhEKWjEqxnnqAr6CpsW09yU"
end

# Checking whether DSP is running successfully
# Checking the connection with Mysql database
Given(/^I want to run DSP APIs$/) do
 puts "Server host: #{$server_host}:#{$port_number}"
 puts "Checking if chandni-chowk is running"
url="http://#{$server_host}:#{$port_number}"
 puts url
uri= URI(url)
Net::HTTP.get(uri)
 puts "Checking if test is able to connect to the database"
 begin
con=Mysql.new($mysql_server, $mysql_user, $mysql_password, $db_name)
 puts con.get_server_info
rs = con.query 'show tables'
 puts "CONNECTED TO DATABASE!!!"
rescue Mysql::Error => e
 puts e.errno
 puts e.error
ensure
con.close if con
 end
end

#########################
#Start Of ListData APIs
#########################

Given(/^I want to run GET APIs$/) do
 puts "Get APIs under List data will run now"
end

# obj calling class Validate 
# storing the return value of method apivalidation in @api_return_value
When(/^I run GET for "([^"]*)" API for the field "([^"]*)"$/) do |api,field|
 if ((api == "get-age" && field == "age") || 
    (api == "get-languages" && field == "language") ||
    (api == "get-campaign-objectives" && field == "campaign_objectives") ||
    (api == "get-product-category" && field == "product_category") ||
    (api == "get-audience-type" && field == "audience_type") ||
    (api == "get-product-sub-category" && field == "product_sub_category") ||
    (api == "get-org-types" && field == "organization_type") ||
    (api == "get-industry-types" && field == "industry_type"))

    obj = Validate.new
    @api_return_value=obj.apivalidation("#{api}","#{field}")
 end
end


# obj1 calling the class Validate
# storing the return value of method dbvalidation in @mongo_return_value
Then(/^I should see correct entries from table "([^"]*)" for field "([^"]*)"$/) do |table_name,field|
 if ((table_name == "channel_reach" && field == "age") ||
    (table_name == "channel_mappings" && field == "language") ||
    (table_name == "campaign_objectives" && field == "campaign_objectives") ||
    (table_name == "product_category" && field == "product_category") ||
    (table_name == "profile_to_tg" && field == "audience_type") ||
    (table_name == "product_sub_category" && field == "product_sub_category") ||
    (table_name == "organization_types" && field == "organization_type") ||
    (table_name == "industry_types" && field == "industry_type"))
    
    obj1 = Validate.new
    @mongo_return_value=obj1.dbvalidation("#{table_name}","#{field}")
    obj2 = Validate.new
    final_ans = 0
# calling compare method
  if final_ans == obj2.compare(@api_return_value,@mongo_return_value)
     puts "Match"
     else
     puts "Mismatch"
  end
 end
end

# For the APIs with multiple fields
When(/^I run GET for "([^"]*)" API$/) do |api|
 if api == "get-regions" || api == "get-country-state-mappings"
    objm = Validate.new
    @api_return_values=objm.apivalidationmul("#{api}")
 end
end

Then(/^I should see correct entries from table "([^"]*)"$/) do |table_name|
 if table_name == "regions" || table_name == "country_state_mappings"
    obj1m = Validate.new
    @mongo_return_values=obj1m.dbvalidationmul("#{table_name}")
    obj2m = Validate.new
    final_ans = 0
# calling compare method
  if final_ans == obj2m.compare(@api_return_values,@mongo_return_values)
     puts "Match"
     else
     puts "Mismatch"
  end
 end
end


# updating entries in db and validating the APIs
When(/^I update "([^"]*)" table with "([^"]*)" entry$/) do |table_name,field|
 if ((table_name == "channel_mappings" && field == "language") ||
    (table_name == "campaign_objectives" && field == "campaign_objectives") ||
    (table_name == "product_category" && field == "product_category") ||
    (table_name == "profile_to_tg" && field == "audience_type") ||
    (table_name == "product_sub_category" && field == "product_sub_category") ||
    (table_name == "organization_types" && field == "organization_type") ||
    (table_name == "industry_types" && field == "industry_type") ||
    (table_name == "channel_reach" && field == "age")||
    (table_name == "country_state_mappings" && field == "state") ||
    (table_name == "regions" && field == "region"))
    obju = Validate.new
    obju.update("#{table_name}","#{field}")
 end
end

Then(/^I should see correct and updated response in "([^"]*)" API for the field "([^"]*)"$/) do |api,field|
 if ((api == "get-languages" && field == "language")||
    (api == "get-campaign-objectives" && field == "campaign_objectives") ||
    (api == "get-product-category" && field == "product_category") ||
    (api == "get-audience-type" && field == "audience_type") ||
    (api == "get-product-sub-category" && field == "product_sub_category")||
    (api == "get-org-types" && field == "organization_type") ||
    (api == "get-industry-types" && field == "industry_type")||
    (api == "get-age" && field == "age") ||
    (api == "get-country-state-mappings" && field == "state") ||
    (api == "get-regions" && field == "region"))
    objuv = Validate.new
    result = "Match"
  if result == objuv.updatevalidation("#{api}","#{field}")
     puts "Update validation is successfull"
  end
 end
end


# deleting entries in db and validating the APIs
When(/^I delete an entry from "([^"]*)" table for the field "([^"]*)"$/) do |table_name,field|
 if ((table_name == "channel_mappings" && field == "language") ||
    (table_name == "campaign_objectives" && field == "campaign_objectives") ||
    (table_name == "product_category" && field == "product_category") ||
    (table_name == "profile_to_tg" && field == "audience_type") ||
    (table_name == "product_sub_category" && field == "product_sub_category") ||
    (table_name == "organization_types" && field == "organization_type") ||
    (table_name == "industry_types" && field == "industry_type") ||
    (table_name == "channel_reach" && field == "age")||
    (table_name == "country_state_mappings" && field == "state") ||
    (table_name == "regions" && field == "region"))

    objd = Validate.new
    objd.delete("#{table_name}","#{field}")
 end
end

Then(/^I should see the correct and modified response in "([^"]*)" API for the field "([^"]*)"$/) do |api,field|
 if ((api == "get_languages" && field == "language") ||
    (api == "get-campaign-objectives" && field == "campaign_objectives") ||
    (api == "get-product-category" && field == "product_category") ||
    (api == "get-audience-type" && field == "audience_type") ||
    (api == "get-product-sub-category" && field == "product_sub_category") ||
    (api == "get-org-types" && field == "organization_type") ||
    (api == "get-industry-types" && field == "industry_type")||
    (api == "get-age" && field == "age")||
    (api == "get-country-state-mappings" && field == "state")||
    (api == "get-regions" && field == "region"))
    objdv = Validate.new
    result = "Match"
  if result == objdv.deletevalidation("#{api}","#{field}")
     puts "Delete validation is successfull"
  end
 end
end


When(/^I run LISTDATA APIs$/) do
puts "I am running Listdata API to check whether the API's response message is Correct"
end

Then(/^I should see Request completed successfully message and error should be nil for "([^"]*)" API$/) do |api|
	if ((api == "get-languages") || (api == "get-campaign-objectives") || ("get-product-category") || ("get-audience-type") || ("get-product-sub-category") || ("get-age") || ("get-regions") || ("get-country-state-mappings") || ("get-org-types") || ("get-industry-types"))
	objs = Validate.new
	result = "Success"
		if result == objs.messagevalidation("#{api}")
		   puts "Successful"
		end
	end
end

#####################
#End of ListData APIs
#####################


#####################
#Start of Auth APIs
#####################


Given(/^I want to run Authentication APIs$/) do
 puts "Authentication APIs will run now"
end

#Validating create-user API for complete and mandatory data

When(/^I run "([^"]*)" API with "([^"]*)" data$/) do |api, constraint|
 input
  if api == "create-user" && constraint == "complete"
     $email_old = $email
   elsif api == "create-user" && constraint == "mandatory"
	  $pan = ""
#All the fields will be considered and pan number is nil as pan is not mandatory yet
  end
 url = "http://#{$server_host}:#{$port_number}/#{api}"
 puts "curl -X POST -H \"Content-Type: application/json\" -d '{
          \"email\": \"#{$email}\",
           \"password\": \"#{$password}\",
           \"name\": \"#{$name}\",
           \"company_name\": \"#{$company_name}\",
           \"phone\": \"#{$phone}\",
           \"company_type\": \"#{$company_type}\",
           \"user_type\": \"#{$user_type}\",
           \"pan\": \"#{$pan_number}\",
           \"industry_type\": \"#{$industry_type}\"
            }' \"#{url}\""
 output = `curl -X POST -H "Content-Type: application/json" -d '{
           "email": "#{$email}",
           "password": "#{$password}",
           "name": "#{$name}",
           "company_name": "#{$company_name}",
           "phone": "#{$phone}",
           "company_type": "#{$company_type}",
           "user_type": "#{$user_type}",
           "pan": "#{$pan_number}",
           "industry_type": "#{$industry_type}"
            }' "#{url}"`
 response=JSON.parse(output)
 @data=response["data"]
 @name=response["data"]["name"]
 @company_name=response["data"]["company_name"]
 @phone=response["data"]["phone"]
 @pan_number=response["data"]["pan"]
 @company_type=response["data"]["company_type"]
 @industry_type=response["data"]["industry_type"]
 @apimessage=response["messages"][0]
 @permissions=@data["permissions"]
 @password="#{$password}"
#puts @password
 @user_token_create_user=response["data"]["user_token"]
#puts $email_old
end


Then(/^I should see "([^"]*)" message$/) do |message|
	if message == "Account created successfully"
    		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
    		puts @apimessage
    		puts "#{message}"
 	elsif message == "Login successfull"
		Test::Unit::Assertions.assert_equal @apimessage_l,"#{message}"
		puts @apimessage_l
		puts "#{message}"	
#	elsif message == "User does not exist"
#		Test::Unit::Assertions.assert_equal @apimessage_l,"#{message}"
#		puts @apimessage_l
#                puts "#{message}"
	elsif message == "Wrong password"
		Test::Unit::Assertions.assert_equal @apimessage_l,"#{message}"
		puts @apimessage_l
                puts "#{message}"
	elsif message == "Email or password empty"
		Test::Unit::Assertions.assert_equal @apimessage_l,"#{message}"
		puts @apimessage_l
                puts "#{message}"
	elsif message == "Saved successfully"
		Test::Unit::Assertions.assert_equal @apimessage_e,"#{message}"
		puts @apimessage_e
		puts "#{message}"
	elsif message == "Data Missing"
	Test::Unit::Assertions.assert_equal @apimessage_e,"#{message}"
                puts @apimessage_e
                puts "#{message}"
#	elsif message == "Invalid token"
#	Test::Unit::Assertions.assert_equal @apimessage_e,"#{message}"
#                puts @apimessage_e
#                puts "#{message}"
	elsif message == "Change Password Successfull"
	Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
		puts @apimessage
                puts "#{message}"
#	elsif message == "Wrong password"	
#	Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
#                puts @apimessage
#                puts "#{message}"
#	elsif message == "User does not exist"
#		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
#                puts @apimessage
#                puts "#{message}"
	elsif message == "Mail sent"
		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
		puts @apimessage
                puts "#{message}"
	elsif message == "User does not exist"
		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
                puts @apimessage
                puts "#{message}"
	elsif message == "Valid token"
		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
                puts @apimessage
                puts "#{message}"
	elsif message == "Invalid token"
		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
                puts @apimessage
                puts "#{message}"
	elsif message == "Password changed"
		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
                puts @apimessage
                puts "#{message}"
	elsif message == "billing information retrived successfully"
		Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
                puts @apimessage
                puts "#{message}"
	end
end

#Validating create-user API for repititve, invalid and missing data

When(/^I run "([^"]*)" with "([^"]*)"$/) do |api, constraint|
 input
  if api == "create-user"
   if constraint == "existing-email"
     $email = $email_old
   elsif constraint == "invalid-email-dd"
     $email = Faker::Base.regexify("/[a-zA-Z0-9]{6}..1@[a-z]{5}.[a-z]{3}/")
   elsif constraint == "invalid-email-@"
     $email = Faker::Base.regexify("/[a-zA-Z0-9]{6}.[a-z]{3}/")
   elsif constraint == "invalid-email-."
     $email = Faker::Base.regexify("/[a-zA-Z0-9]{6}@[a-z]{5}/")
   elsif constraint == "white-spaces"
     $email = " " + Faker::Internet.free_email
   elsif constraint == "missing-email"
     $email = ""
   #elsif constraint == "invalid-password"
    # $email = Faker::Internet.password(1,5) 
   elsif constraint == "missing-password"
     $password = ""
   elsif constraint == "invalid-phone-chars"
     $phone = Faker::Base.regexify("/[a-zA-Z0-9]{10}")
   elsif constraint == "invalid-phone>dig"
     $phone = Faker::Base.regexify("/[0-9]{12}")
   elsif constraint == "invalid-phone<dig"
     $phone = Faker::Base.regexify("/[0-9]{9}")
   elsif constraint == "missing-phone"
     $phone = ""
   elsif constraint == "missing-name"
     $name = ""
   elsif constraint == "missing-company_name"
     $company_name = ""
   end
  end

url = "http://#{$server_host}:#{$port_number}/#{api}"
 output = `curl -X POST -H "Content-Type: application/json" -d '{
           "email": "#{$email}",
           "password": "#{$password}",
           "name": "#{$name}",
           "company_name": "#{$company_name}",
           "phone": "#{$phone}",
           "company_type": "#{$company_type}",
           "user_type": "#{$user_type}",
           "pan": "#{$pan_number}",
           "industry_type": "#{$industry_type}"
            }' "#{url}"`

 response=JSON.parse(output)
 @data=response["data"]
 @apimessage=response["messages"][0]
end

Then(/^I should see "([^"]*)" error message$/) do |message|
 if message == "Input validation failed"
    Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
    puts @apimessage
    puts "#{message}"
 end
end

Then(/^I should see "([^"]*)" exist message$/) do |message|
 if message == "User already exists with this email"
    Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
    puts @apimessage
    puts "#{message}"
 end
end

Then(/^I should see "([^"]*)" missing message$/) do |message|
 if message == "Password cannot be empty"
    Test::Unit::Assertions.assert_equal @apimessage,"#{message}"
    puts @apimessage
    puts "#{message}"
 end
end

#Validating Data in mysql db
Then(/^I should see "([^"]*)" stored in mysql for "([^"]*)" API$/) do |constraint,api|
	if constraint == "valid_data" && api == "create-user"
		info=@data
	elsif constraint == "valid_data" && api == "login"
		info=@data_l
	elsif constraint == "valid_data" && api == "edit-user"
		info=@data_e
	elsif constraint == "valid_data" && api == "create-guest-user"
		info=@data_g
		$email=@email_g
	end
	if constraint == "valid_data" && api == "edit-user"
		begin
		con=Mysql.new($mysql_server, $mysql_user, $mysql_password, $db_name)
		data_query="select name, company_name, phone, company_type, pan, industry_type from user where email = '#{$email}'"
		data_db=con.query(data_query)
		rescue Mysql::Error => e
                        puts e.errno
                        puts e.error
                        ensure
                        con.close if con
		end
		geninfo=data_db.fetch_row
		flag2=1
        	puts "User Data verification"
        	if info[0] == geninfo[0] && info[1] == geninfo[1] && info[2] == geninfo[2] && info[3] == geninfo[3] && info[4] == geninfo[4] && info[5] == geninfo[5] && info[6] == geninfo[6] 
                flag2=0
                puts geninfo
                puts "Data Matches"
        end
Test::Unit::Assertions.assert_equal(flag2,0)		

	else
		begin
		con=Mysql.new($mysql_server, $mysql_user, $mysql_password, $db_name)
		data_query="select email, name, company_name, phone, state, city, company_type, user_type, active from user where email='#{$email}'"
                data_db=con.query(data_query)
		rescue Mysql::Error => e
                        puts e.errno
                        puts e.error
                        ensure
                        con.close if con
                end

	        geninfo=data_db.fetch_row
                if geninfo[-1] = 0
                        active=false
                        else
                        active=true
                end
flag2=1
        puts "User Data verification"
        if info["email"] == geninfo[0] && info["name"] == geninfo[1] && info["company_name"] == geninfo[2] && info["phone"] == geninfo[3] && info["state"] == geninfo[4] && info["city"] == geninfo[5] && info["company_type"] == geninfo[6] && info["user_type"] == geninfo[7] && info["active"] == active
                flag2=0
                puts geninfo
                puts "Data Matches"
        end
Test::Unit::Assertions.assert_equal(flag2,0)
end
end

	


#Validating permissions of the users
Then(/^I should see valid permissions for "([^"]*)" user from mysql db$/) do |user|
	if user == "create-user"
        	perm=@permissions
	elsif user == "login"
		perm=@permissions_l
	elsif user == "create-guest-user"
		perm=@permissions_g
	end
flag = 1
		begin
		con=Mysql.new($mysql_server, $mysql_user, $mysql_password, $db_name)
		perm_query="select p.id, p.url, p.name, p.permission_code, ct.content_type from user_role ur inner join role r on ur.role_id=r.id inner join role_permission rp on r.id=rp.role_id  inner join permission p on p.id=rp.permission_id inner join content_type ct on ct.id=p.content_type_id where ur.user_id in (select id from user where email='#{$email}');"
		perm_db=con.query(perm_query)
		permission_rows=perm_db.num_rows

#		data_query="select email, name, company_name, phone, state, city, company_type, user_type, active from user where email='#{$email}'"
#		data_db=con.query(data_query)
			rescue Mysql::Error => e
			puts e.errno
			puts e.error
			ensure
			con.close if con
		end
	puts perm
	permission_rows.times do
        	ans=perm_db.fetch_row
        	puts ans
        	flag=1
        	perm.each do |permission|
                	if ans[0].to_i == permission["permission_id"].to_i && ans[1] == permission["url"] && ans[2] == permission["name"] && ans[3] == permission["permission_code"] && ans[4] == permission["content_type"]
                        flag=0
                        puts "Permission code for this row matches!"
                	end
		end
        		if flag == 1
                	puts "Oops no match!"
                	break
			end
  	end

Test::Unit::Assertions.assert_equal(flag,0)

end

#Login API

When(/^I run "([^"]*)" API with "([^"]*)" Email and "([^"]*)" Password$/) do |api, constraint1, constraint2|
	if api == "login" && constraint1 == "Valid_id" && constraint2 == "Valid"
		email = $email_old
		password = @password
	elsif api == "login" && constraint1 == "Invalid_id" && constraint2 == "Valid"
		email = Faker::Internet.free_email
		password = @password
	elsif api == "login" && constraint1 == "Valid_id" && constraint2 == "Invalid"
		email = $email_old
		password = Faker::Internet.password
	elsif api == "login" && constraint1 == "Empty" && constraint2 == "Empty"
		email = ""
		password = ""
	elsif api == "login" && constraint1 == "Valid_id" && constraint2 == "New"
		email = $email_old
		password = @new_password 
	elsif api == "login" && constraint1 == "Valid_id" && constraint2 == "Old"
		email = $email_old
		password = @password 
	end

url = "http://#{$server_host}:#{$port_number}/#{api}"
output=`curl -X POST -H "Content-Type: application/json" -d '{
    "email": "#{email}",
    "password": "#{password}"
        }' "#{url}"`
puts "curl -X POST -H \"Content-Type: application/json\" -d '{
    \"email\": \"#{email}\",
    \"password\": \"#{password}\"
        }' \"#{url}\""

response=JSON.parse(output)
@data_l=response["data"]
@apimessage_l=response["messages"][0]
puts @apimessage_l
#@user_token_login=response["data"]["user_token"]
#@permissions_l=@data["permissions"]
end

#edit user section

When(/^I run "([^"]*)" API with "([^"]*)" details using "([^"]*)" user token$/) do |api,constraint1,constraint2|
	if api == "edit-user" && constraint1 == "Valid" && constraint2 == "Valid"
		@name = Faker::Name.name
		@company_name = Faker::Company.name
		@phone = Faker::Number.number(10)
		@company_type = $c_list[rand($c_list.length)]
		@pan_number = Faker::Base.regexify("/[ABCFGHLJPT]{5}[0-9]{4}[ABCFGHLJPT]{1}/")
		@industry_type = $i_list[rand($i_list.length)]
	elsif api == "edit-user" && constraint1 == "missing" && constraint2 == "Valid"		
		@name = ""
		@company_name = ""
		@phone = ""
		@pan = ""
		@company_type = ""
		@industry_type = ""
	elsif api == "edit-user" && constraint1 == "Invalid" && constraint2 == "Valid"
		@phone = "457yfr@0"
	elsif api == "edit-user" && constraint1 == "Invalid" && constraint2 == "Invalid"
		input
		@user_token_create_user = $timedout_user_token
#		@user_token_create_user = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0NjQ2ODY0NzEsImlhdCI6MTQ2NDA4MTY3MSwic3ViIjoiMWJmYWRkN2MtZWFlOS00M2FkLWIzNmYtMjk0MmY0NDQzYjM4In0.TxxjfPW3KIMyUD7-Hv1NcrJ2CpPiOBq1Qp09G9uoNQwuI4oto6X0Kbpwx6T7t3Dgo8ZOGtOP_Vy_wghi4xhEnTEkfMtrtVrlt1avVuisGrMDZyCVpwJ5ZGClOIb4y7X_azeRv10RrDmaWG4duXyikhEKWjEqxnnqAr6CpsW09yU"
	end

url = "http://#{$server_host}:#{$port_number}/#{api}"
puts "curl -X POST -H \"Authorization: #{@user_token_create_user}\" -H \"Content-Type: application/json\" -d '{
           \"name\": \"#{@name}\",
           \"company_name\": \"#{@company_name}\",
           \"phone\": \"#{@phone}\",
           \"company_type\": \"#{@company_type}\",
           \"pan\": \"#{@pan_number}\",
          \"industry_type\": \"#{@industry_type}\"
            }' \"#{url}\""
output = `curl -X POST -H "Authorization: #{@user_token_create_user}" -H "Content-Type: application/json" -d '{
           "name": "#{@name}",
           "company_name": "#{@company_name}",
           "phone": "#{@phone}",
           "company_type": "#{@company_type}",
           "pan": "#{@pan_number}",
           "industry_type": "#{@industry_type}"
            }' "#{url}"`


response=JSON.parse(output)
@data_e=["#{@name}","#{@company_name}","#{@phone}","#{@company_type}","#{@pan_number}","#{@industry_type}"]
puts @data_e
@apimessage_e=response["messages"][0] 
end


#Change password API
When(/^I run "([^"]*)" API for "([^"]*)" email and "([^"]*)" old password and "([^"]*)" new password$/) do |api, email, pwd, new_pwd|
	if api == "change-password"
		if email == "Valid" && pwd == "Valid" && new_pwd == "Valid"
			$email = $email_old
			$password = @password
			@new_password = Faker::Internet.password(8)
		elsif email == "Valid" && pwd == "Valid" && new_pwd == "Invalid"
			$email = $email_old
                        $password = @new_password
                        @new_password = Faker::Internet.password(5)
		elsif email == "Valid" && pwd == "Invalid" && new_pwd == "Valid"
			$email = $email_old
                        $password = Faker::Internet.password(6)
                        @new_password = Faker::Internet.password(8)
		elsif email == "Invalid" && pwd == "Valid" && new_pwd == "Valid"
			$email = Faker::Internet.free_email 
                        $password = @password
                        @new_password = Faker::Internet.password(8)
		elsif email == "Invalid" && pwd == "Invalid" && new_pwd == "Valid"
			$email = Faker::Internet.free_email
                        $password = Faker::Internet.password(6)
                        @new_password = Faker::Internet.password(8)
		end
	


url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X POST -H "Accept: application/json" -d '{
"email":"#{$email}",
"old_password":"#{$password}",
"new_password":"#{@new_password}"
}' "#{url}"`
puts output

puts "curl -X POST -H \"Accept: application/json\" -d '{
\"email\":\"#{$email}\",
\"old_password\":\"#{$password}\",
\"new_password\":\"#{@new_password}\"
}' \"#{url}\""
response=JSON.parse(output)
@apimessage=response["messages"][0]
#puts @apimessage
end
end

#Forgot password
When(/^I run "([^"]*)" API for "([^"]*)" email$/) do |api, email|
input
	if api == "forgot-password" && email == "Valid"
	email = $email_old
	elsif api == "forgot-password" && email == "Invalid"
	email = $email
	end
url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X POST -d '{
"email":"#{email}",
"target_url":"www.google.com/token="
}' "#{url}"`

puts "curl -X POST -d '{
\"email\":\"#{email}\",
\"target_url\":\"www.google.com/token=\"
}' \"#{url}\""
response=JSON.parse(output)
@apimessage=response["messages"][0]
#puts @apimessage
end


#is-valid-forgot-password-token
When(/^I run "([^"]*)" with "([^"]*)" user token$/) do |api,constraint|
input 
	if api == "is-valid-forgot-password-token" && constraint == "Valid"
	user_token = @user_token_create_user
	elsif api == "is-valid-forgot-password-token" && constraint == "Invalid"
	user_token = $timedout_user_token 
	end
url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X POST -d '{"token":"#{user_token}"}' "#{url}"`
response=JSON.parse(output)
@apimessage=response["messages"][0]
end

#change forgot password API
When(/^I run "([^"]*)" API with "([^"]*)" user token and "([^"]*)" new password$/) do |api, constraint, constraint1|
input
	if api == "change-forgot-password" && constraint == "Valid" && constraint1 == "Valid"
		user_token = @user_token_create_user
		@new_password = $password 
	elsif api == "change-forgot-password" && constraint == "Valid" && constraint1 == "Invalid"
		user_token = @user_token_create_user
		@new_password = Faker::Internet.password(5)
	elsif api == "change-forgot-password" && constraint == "Invalid" && constraint1 == "Valid"
		user_token = $timedout_user_token
		@new_password = $password
	end
url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X POST -d '{"token":"#{user_token}", "new_password":"#{@new_password}"}' "#{url}"`
response=JSON.parse(output)
@apimessage=response["messages"][0]
end

#Create guest user API
When(/^I run "([^"]*)" API$/) do |api|
	if api == "create-guest-user"
url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X GET "#{url}"`
puts output
response=JSON.parse(output)
 @data_g=response["data"]
 @email_g=response["data"]["email"]
 @name=response["data"]["name"]
 @company_name=response["data"]["company_name"]
 @phone=response["data"]["phone"]
 @pan_number=response["data"]["pan"]
 @company_type=response["data"]["company_type"]
 @industry_type=response["data"]["industry_type"]
 @apimessage=response["messages"][0]
 @permissions_g=@data["permissions"]
#@password="#{$password}"
#puts @password
 @user_token_create_guest_user=response["data"]["user_token"]
@user_token_create_guest_user.destroy
end

end


####################
#End of Authentication APIs
#################### 

#####################
#Billing APIs
#####################

Given(/^I want to run Billing APIs$/) do
puts "Billing APIs will run now"
end

When(/^I run "([^"]*)" API with "([^"]*)" user_token$/) do |api, constraint|
input
	if api == "get-billing-informations" && constraint == "Valid"
		@user_token = @user_token_create_user 
	elsif api == "get-billing-informations" && constraint == "Invalid"
		@user_token = $timedout_user_token 
	end
url = "http://#{$server_host}:#{$port_number}/#{api}"		
output = `curl -X GET -H "Authorization: #{@user_token}" -H "Content-Type: application/json" "#{url}"`
puts output
response=JSON.parse(output)
@apimessage=response["messages"][0]
end








# class to validate
# method apivalidation to return api response in array format
# method dbvalidation to return exact db values from mongo in array format
# method compare to compare the arrays returned by both the above methods
class Validate

def apivalidation(api,field)
url = "http://#{$server_host}:#{$port_number}/#{api}"
output=`curl -X GET -H "Authorization: #{@user_token}" -H "Content-Type: application/json" "#{url}"`
response=JSON.parse(output)
@data=response["data"]["#{field}"]
puts "=========================================="
puts @data
puts "=========================================="
return @data
end

def messagevalidation(api)
url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X GET -H "Content-Type: application/json" "#{url}"`
response=JSON.parse(output)
@messages = response["messages"][0]
@error = response["error"]
puts @messages
Test::Unit::Assertions.assert_equal @messages, "Request completed successfully"
Test::Unit::Assertions.assert_equal @error, nil
return "Success"
end

# for the APIs with multiple fields
def apivalidationmul(api)
url = "http://#{$server_host}:#{$port_number}/#{api}"
output=`curl -X GET -H "Authorization: #{@user_token}" -H "Content-Type: application/json" "#{url}"`
response=JSON.parse(output)
@data=response["data"]
puts "=========================================="
puts @data
puts "=========================================="
return @data
end

def dbvalidation(table_name,field)
mongo_client = Mongo::Client.new($mongo_connect_string)
list=mongo_client[:"#{table_name}"].find.to_a
@arr_elements=Array.new
list.each do |a|
ans = a["#{field}"]
 if (@arr_elements.include? ans) == false 
    @arr_elements.insert(-1,ans)
 end
end
puts "==========================================="
puts @arr_elements
puts "==========================================="
return @arr_elements
end

# for collections with multiple fields
def dbvalidationmul(table_name)
mongo_client = Mongo::Client.new($mongo_connect_string)
@list=mongo_client[:"#{table_name}"].find.to_a
# mongo collections have fields called "_id" which is not returned by api response
# deleting the "_id" field from mongo response to map api response
@list.each do |l|
l.delete("_id")
end
puts "==========================================="
puts @list
puts "==========================================="
return @list
end

def compare(arr_elements,data)
 if (arr_elements - data).empty?
    @flag=0
    else
    @flag=1
 end
Test::Unit::Assertions.assert_equal @flag, 0
return @flag
end

#for updating GET APIs 
def update(table_name, field)
mongo_client = Mongo::Client.new($mongo_connect_string)
 if table_name == "channel_reach" && field == "age"
    result=mongo_client[:"#{table_name}"].insert_one({ "#{field}": '100' })
    elsif table_name == "country_state_mappings" && field == "state"
    result = mongo_client[:"#{table_name}"].insert_one({ country: "India", state: "TestState" })
    elsif table_name == "regions" && field == "region"
    result = mongo_client[:"#{table_name}"].insert_one({ "#{field}": "Test Region", type: "Metro", location: "East", contained_in: "N/A" })
 else
    result=mongo_client[:"#{table_name}"].insert_one({ "#{field}": 'Test New' })
 end
end


#For validating the updated entries
def updatevalidation(api,field)
#@call = apivalidation("#{api_value}","#{field_value}")
 if api == "get-age" && field == "age"
    @call = apivalidation("#{api}","#{field}")
  if @call.include? '100'
     return "Match"
     else 
     return "Mismatch"
  end
 elsif (api == "get-country-state-mappings" && field == "state")
        @call = apivalidationmul("#{api}")
        @call.each do |call|

  if call["state"].include? 'TestState'
     return "Match"
     else 
     return "Mismatch"
  end
  end
 elsif (api == "get-regions" && field == "region")
        @call = apivalidationmul("#{api}")
        @call.each do |call|
  if call["region"].include? 'Test Region'
     return "Match"
     else
     return "Mismatch"
  end
  end
 else
     @call = apivalidation("#{api}","#{field}")
  if @call.include? 'Test New'
     return "Match"
     else 
     return "Mismatch"
  end
 end
end


#for deleting GET APIs
def delete(table_name, field)
mongo_client = Mongo::Client.new($mongo_connect_string)
 if table_name == "channel_reach" && field == "age"
 result=mongo_client[:"#{table_name}"].delete_one({ "#{field}": '100' })
 elsif table_name == "country_state_mappings" && field == "state"
 result = mongo_client[:"#{table_name}"].delete_one({ country: "India", "#{field}": "TestState" })
 elsif table_name == "regions" && field == "region"
 result = mongo_client[:regions].delete_one({ region: "Test Region", type: "Metro", location: "East", contained_in: "N/A" })
 else
 result=mongo_client[:"#{table_name}"].delete_one({ "#{field}": 'Test New' })
 end
end

#for validating the modified entries
def deletevalidation(api,field)
 if api == "get-age" && field == "age"
    @call=apivalidation("#{api}","#{field}")
  if @call.include? '100'
     return "Mismatch"
     else
     return "Match"
  end
 elsif ((api == "get-country-state-mappings" && field == "state") ||
       (api == "get-regions" && field == "region"))
       @call=apivalidationmul("#{api}")
       @call.each do |call|
   if ((call.include? 'TestState') ||
       (call.include? 'Test Region'))
   return "Mismatch"
   else
   return "Match"
   end
   end

 else
     @call=apivalidation("#{api}","#{field}")
   if @call.include? 'Test New'
   return "Mismatch"
   else
   return "Match"
   end
 end
end
end


################################### Bug Verify Instant ########################################

When(/^I run "([^"]*)" with "([^"]*)" user_token$/) do |api, constraint|
if api == "get-campaign-name" && constraint == "Valid"
@user_token = @user_token_create_user
elsif api == "get-users-campaign-list" && constraint == "Valid"
@user_token = @user_token_create_user
end
url = "http://#{$server_host}:#{$port_number}/#{api}"
output = `curl -X GET -H "Authorization: #{@user_token}" "#{url}"`
puts output
response=JSON.parse(output) 
@campaign_name=response["data"]
puts @campaign_name
end



When(/^I run "([^"]*)" with "([^"]*)" campaign_name$/) do |api, constraint|
if api == "is-valid-campaign-name" && constraint == "Valid"
@user_token = @user_token_create_user
@campaign_name = @campaign_name
end

output = `curl -X GET -H "Content-Type: application/json" -H "Authorization: #{@user_token}" "http://#{$server_host}:#{$port_number}/#{api}?campaign_name=#{@campaign_name}"`
puts output
end



When(/^I run "([^"]*)" API with "([^"]*)" campaign_id$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end



When(/^I run "([^"]*)" API for instant$/) do |api|
if api = "save-campaign"

end
url = "http://#{$server_host}:#{$port_number}/#{api}"
 output=`curl -X POST -H "Authorization: #{user_token}" -H "Content-Type: application/json" -d '{ 
              "_id": #{@campaign_id}, 
              "campaign_settings": {
                "campaign_name": "#{@campaign_name}",
                "brand_name": "#{@brand_name}",
                "product_category": "#{@product_category}",
                "product_sub_category": "#{@product_sub_category}",
                "campaign_objective": "#{@campaign_objective}",
                "gender": ["#{@gender}"],
                "age": ["#{@age}"],
                "audience_type": ["#{@audience_type}"],
                "geography": ["#{@geography}"],
                "creative_format": ["#{@creative_format}"],
                "currency": "#{@currency}",
                "lakh": #{@lakh},
                "thousand": #{@thousand},
                "campaign_start_date": "#{@campaign_start_date}",
                "duration": #{@duration}
              }
              }' "#{url}"`
puts ouput
end
