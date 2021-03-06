require File.dirname(__FILE__) + '/helper'

class PersonTest < Test::Unit::TestCase
  context "when an api caller is authenticated" do
    setup do
      @api_key = '123123123123123123123'
      CreateSend.api_key @api_key
      @client_id = "d98h2938d9283d982u3d98u88"
      @person = CreateSend::Person.new @client_id, "person@example.com"
    end
    
    should "get a person by client id and email address" do
      email = "person@example.com"
      stub_get(@api_key, "clients/#{@client_id}/people.json?email=#{CGI.escape(email)}", "person_details.json")      
      person = CreateSend::Person.get @client_id, email
      person.EmailAddress.should == email
      person.Name.should == "Person One"
      person.AccessLevel.should == 1023
      person.Status.should == "Active"
    end

    should "add a person" do
      stub_post(@api_key, "clients/#{@client_id}/people.json", "add_person.json")
      result = CreateSend::Person.add @client_id, "person@example.com", "Person", 0, "Password"
      result.EmailAddress.should == "person@example.com"
    end

    should "update a person" do
      email = "person@example.com"
      new_email = "new_email_address@example.com"
      stub_put(@api_key, "clients/#{@client_id}/people.json?email=#{CGI.escape(email)}", nil)
      @person.update new_email, "Person", 1023, "NewPassword"
      @person.email_address.should == new_email
    end
      
    should "delete a person" do
      stub_delete(@api_key, "clients/#{@person.client_id}/people.json?email=#{CGI.escape(@person.email_address)}", nil)
      @person.delete
    end
  end
end