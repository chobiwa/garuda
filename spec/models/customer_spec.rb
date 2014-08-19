require "rails_helper"

describe Customer, :type => :model do

  it "should create a new customer" do
    Customer.create name: "Chobi", email: "chobi@goo.com", mobile: "919611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    all_customers = Customer.all   
    
    all_customers.length.should == 1
    expected_customer = all_customers.first

    expected_customer.name.should == "Chobi"
    expected_customer.mobile.should == "919611805469"
    expected_customer.email.should == "chobi@goo.com"
    expected_customer.address.should == "20, blah, blah"
    expected_customer.occupation.should == "Blah"
    expected_customer.gender.should == "M"
    expected_customer.age.should == 78
  end
  
end