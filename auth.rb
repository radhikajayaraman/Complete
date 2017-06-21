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
$pan_number = Faker::Base.regexify("/[A-Z]{5}[0-9]{4}[A-Z]{1}/")
$i_list = ["Apparels","Garments","Advertising"] 
$industry_type = $i_list[rand($i_list.length)] 
end


Given(/^I want to run Authentication APIs$/) do
 puts "Authentication APIs will run now"
end

#Validating create-user API for complete and mandatory data

When(/^I run "([^"]*)" API with "([^"]*)" data$/) do |api, constraint|
 input
  if api == "create-user" && constraint == "complete"
     $email_old = $email 
   elsif api == "create-user" && constraint == "mandatory"
         $company_type = ""
         $user_type = ""
         $pan_number = ""
         $industry_type = ""
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
 @permissions=@data["permissions"]
 puts @permissions
end


Then(/^I should see "([^"]*)" message$/) do |message|
 if message == "Account created successfully"
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

Then(/^I should see "([^"]*)" from db$/) do |perm|
 if perm == "proper-permissions"
   puts @permissions
 end
end
=begin
Then(/^I should see status "([^"]*)"$/) do |expected_status|
  status=@ans["error"]["status"]
  Test::Unit::Assertions.assert_equal status.to_i, expected_status.to_i
end

Then(/^I should see correct data for "([^"]*)" user$/) do |arg1|
  flag=1
  begin
    con=Mysql.new($server_host, $mysql_user, $mysql_password, $db_name)
    permissions_query="select p.id, p.url, p.name, p.permission_code, ct.content_type from user_role ur inner join role r on ur.role_id=r.id inner join role_permission rp on r.id=rp.role_id  inner join permission p on p.id=rp.permission_id inner join content_type ct on ct.id=p.content_type_id where ur.user_id in (select id from user where email='#{$email}');"
    puts "Executing query:::  #{permissions_query}"
    permissions=con.query(permissions_query)
    permission_rows=permissions.num_rows
puts "Number of permission rows is #{permission_rows}"
    gen_info_query="select email, name, company_name, phone, state, city, company_type, user_type, active from user where email='#{$email}'"

    puts "Executing query::: #{gen_info_query}"
    gen_info=con.query(gen_info_query)

  rescue Mysql::Error => e
    puts e.errno
    puts e.error
  ensure
    con.close if con
  end

  info=@ans["data"]
  perm=info["permissions"]

  puts "+++DEBUG+++"
  puts info
  puts perm
  permission_rows.times do
    ans=permissions.fetch_row
    puts "+++DEBUG+++ rows from database"
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
  geninfo=gen_info.fetch_row
  if geninfo[-1] = 0
    active=false
  else
    active=true
  end
  flag2=1
  puts "General information verification"
  if info["email"] == geninfo[0] && info["name"] == geninfo[1] && info["company_name"] == geninfo[2] && info["phone"] == geninfo[3] && info["state"] == geninfo[4] && info["city"] == geninfo[5] && info["company_type"] == geninfo[6] && info["user_type"] == geninfo[7] && info["active"] == active
    flag2=0
    puts "General info matches"
  end

  Test::Unit::Assertions.assert_equal(flag,0)
  Test::Unit::Assertions.assert_equal(flag2,0)
end

Then(/^I should see "([^"]*)" message for "([^"]*)" API$/) do |expected_message, api|
  if api == "create-user" || ((api == "save-billing-information" || api == "update-billing-information" || api == "edit-user") && expected_message == "Un-authorized") || api == "get-billing-informations" || api == "change-forgot-password"  || ( api == "save-campaign" && expected_message == "Un-authorized" )
    message=@ans["error"]["title"]
    puts "Printing error title: #{message}"
  elsif api == "login" || api == "change-password" || api == "edit-user" || api == "save-billing-information" || api == "delete-billing-information" || api == "update-billing-information" || api == "create-guest-user" || api == "forgot-password" || ( api == "save-campaign" && expected_message == "Campaign saved successfully" ) || api == "save-creative" || api == "unlink-creative" || api == "delete-campaign"
    message=@ans["messages"][0]
  end

  puts message
  puts expected_message
  Test::Unit::Assertions.assert_match message, expected_message
end
=end
