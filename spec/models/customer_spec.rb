require "rails_helper"

describe Customer, :type => :model do

  it "should create a new customer" do
    Customer.create! name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    all_customers = Customer.all   
    
    all_customers.length.should == 1
    expected_customer = all_customers.first

    expected_customer.name.should == "Chobi"
    expected_customer.mobile.should == "9611805469"
    expected_customer.email.should == "chobi@goo.com"
    expected_customer.address.should == "20, blah, blah"
    expected_customer.occupation.should == "Blah"
    expected_customer.gender.should == "M"
    expected_customer.age.should == 78
  end

  it "should ensure presence of name" do 
    Customer.create name: "", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    all_customers = Customer.all   
    all_customers.length.should == 0
  end

  it "should ensure presence of email" do 
    Customer.create name: "name", email: "", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    all_customers = Customer.all   
    all_customers.length.should == 0
  end

  it "should ensure format of email" do 
    Customer.create name: "name", email: "foo@bar", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    all_customers = Customer.all   
    all_customers.length.should == 0
  end

  it "should ensure presence of mobile number" do 
    Customer.create name: "name", email: "foo@br.com", mobile: "", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    all_customers = Customer.all   
    all_customers.length.should == 0
  end

  it "should ensure uniqueness of mobile number" do 
    Customer.create! name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    expect {
      Customer.create! name: "ChobiX", email: "xchobi@goo.com", mobile:"9611805469", address: "20X, blah, blah", occupation: "BlahX", gender: "F", age: 98
    }.to raise_error(ActiveRecord::RecordNotUnique)

    all_customers = Customer.all   
    all_customers.length.should == 1
  end

  it "should allow non mandatory fields to be empty" do
    Customer.create! name: "Chobi", email: "chobi@goo.com", mobile: "9611805469"

    all_customers = Customer.all   
    
    all_customers.length.should == 1
    expected_customer = all_customers.first
    
    expected_customer.name.should == "Chobi"
    expected_customer.mobile.should == "9611805469"
    expected_customer.email.should == "chobi@goo.com"
    expected_customer.address.should == nil
    expected_customer.occupation.should == nil
    expected_customer.gender.should == nil
    expected_customer.age.should == nil
  end
  
end