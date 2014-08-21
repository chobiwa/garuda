require "rails_helper"

describe Transactionitem, :type => :model do

  it "should create a transactionitem" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122ABC", store_id: 1, amount: 1000, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 1

  	expected_transactionitems = all_transactionitems.first

  	expected_transactionitems.transaction_id.should == 1
  	expected_transactionitems.item_id.should == "122ABC"
  	expected_transactionitems.store_id.should == 1
  	expected_transactionitems.amount.should == 1000
  	expected_transactionitems.date.to_s.should	 ==  '2012-03-04'

  end

  it "should ensure presence of store_id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122ABC", store_id: nil, amount: 1000, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0


  end

  it "should ensure presence of transaction_id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: nil, item_id: "122ABC", store_id: 1, amount: 1000, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	

  end

  it "should ensure presence of amount" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122ABC", store_id: 1, amount: nil, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	

  end

  it "should ensure presence of date" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122ABC", store_id: 1, amount: 2000, date: nil

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	

  end

  it "should ensure presence of item_id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: nil, store_id: 1, amount: 2000, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	

  end

  it "should ensure unique combination of item_id and store_id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122ABC", store_id: 1, amount: 2000, date: '2012-03-04'

  	expect {
  		Transactionitem.create transaction_id: 1, item_id: "122ABC", store_id: 1, amount: 2000, date: '2012-03-04'
    }.to raise_error(ActiveRecord::RecordNotUnique)


  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 1
  	
  	expected_transactionitems = all_transactionitems.first

  	expected_transactionitems.transaction_id.should == 1
  	expected_transactionitems.item_id.should == "122ABC"
  	expected_transactionitems.store_id.should == 1
  	expected_transactionitems.amount.should == 2000
  	expected_transactionitems.date.to_s.should	 ==  '2012-03-04'

  end

  it "should not create a transactionitem with non existent store_id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122pqr", store_id: 2, amount: 2000, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	
  end
 
  it "should not create a transactionitem with non existent transaction_id" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 2, item_id: "122pqr", store_id: 1, amount: 2000, date: '2012-03-04'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	
  end

  it "should not create a transactionitem with invalid date" do

    Customer.create! id: 1, name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78

  	Transaction.create id: 1, customer_id: 1, date: '2012-03-14'
  	Store.create id: 1, name: 'MAX'
  	Transactionitem.create transaction_id: 1, item_id: "122pqr", store_id: 2, amount: 2000, date: '2012-03-1128'

  	all_transactionitems = Transactionitem.all
  	all_transactionitems.length.should == 0
  	
  end

end
