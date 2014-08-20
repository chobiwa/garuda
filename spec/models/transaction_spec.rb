require "rails_helper"

describe Transaction, :type => :model do

  it "should create a transaction" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create customer_id: 1, date: '2012-03-14'

  	all_transactions = Transaction.all
  	all_transactions.length.should == 1

  	expected_transaction = all_transactions.first

  	expected_transaction.customer_id.should == 1
  	expected_transaction.date.to_s.should	 ==  '2012-03-14'

  end

  it "should not create a transaction with non existent customer id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

    Transaction.create customer_id: 100, date: '2012-03-14'

    all_transactions = Transaction.all
    all_transactions.length.should == 0


  end
  it "sholud ensure presence of customer_id" do
  	
    Transaction.create customer_id: nil, date: '2012-03-14'

    all_transactions = Transaction.all
    all_transactions.length.should == 0

  end

  it "sholud ensure presence of date" do
    
    Transaction.create customer_id: 1, date: nil

    all_transactions = Transaction.all
    all_transactions.length.should == 0

  end
end
