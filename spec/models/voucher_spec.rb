require "rails_helper"

describe Voucher, :type => :model do

  it "should create a Voucher" do
    cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc"
    voucher.save

  	all_vouchers = Voucher.all

  	all_vouchers.length.should == 1
  	expected_voucher = all_vouchers.first
  	expected_voucher.barcode_number.should == '#123abc'
  end


  it "should mark an existing voucher as a winning vocuher" do 
    cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc"
    voucher.save

    v = Voucher.first
    v.mark_as_winner
    v.save!

    v = Voucher.first
    v.is_winner?.should == true
    v.win_date.should == Date.today
  end

  it "should ensure presence of barcode_number" do
  	cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new
    voucher.save

  	all_vouchers = Voucher.all

  	all_vouchers.length.should == 0
  end

  it "should ensure uniqueness of barcode_number" do
    cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc"
    voucher.save

  	expect {
      voucher = transaction.vouchers.new barcode_number: "#123abc"
      voucher.save!
  	}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Barcode number Voucher Taken")

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 1
  	expected_voucher = all_vouchers.first
  	expected_voucher.barcode_number.should == '#123abc'
  end

  it "should ensure presence of a transaction" do
    expect {
      voucher = Voucher.new barcode_number: "#different"
      voucher.save!
    }.to raise_error(ActiveRecord::StatementInvalid)
  end

end