require "rails_helper"

describe Voucher, :type => :model do

  it "should create a Voucher" do
    cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc", scratch_code: "#abc123"
    voucher.save

  	all_vouchers = Voucher.all

  	all_vouchers.length.should == 1
  	expected_voucher = all_vouchers.first
  	expected_voucher.barcode_number.should == '#123abc'
  	expected_voucher.scratch_code.should == '#abc123'
  end

  it "should ensure presence of barcode_number" do
  	cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new scratch_code: "#abc123"
    voucher.save

  	all_vouchers = Voucher.all

  	all_vouchers.length.should == 0
  end

  it "should ensure presence of scratch_code" do
  	cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc"
    voucher.save

  	all_vouchers = Voucher.all

  	all_vouchers.length.should == 0
  end

  it "should ensure uniqueness of barcode_number" do
    cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc", scratch_code: "#abc123"
    voucher.save

  	expect {
      voucher = transaction.vouchers.new barcode_number: "#123abc", scratch_code: "#different"
      voucher.save
  	}.to raise_error(ActiveRecord::RecordNotUnique)

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 1
  	expected_voucher = all_vouchers.first
  	expected_voucher.barcode_number.should == '#123abc'
  	expected_voucher.scratch_code.should == '#abc123'
  end

  it "should ensure uniqueness of scratch_code" do
  	cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc", scratch_code: "#abc123"
    voucher.save

  	expect {
    	voucher = transaction.vouchers.new barcode_number: "#different", scratch_code: "#abc123"
      voucher.save
  	}.to raise_error(ActiveRecord::RecordNotUnique)

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 1
  	expected_voucher = all_vouchers.first
  	expected_voucher.barcode_number.should == '#123abc'
  	expected_voucher.scratch_code.should == '#abc123'
  end

  it "should ensure presence of a transaction" do
    expect {
      voucher = Voucher.new barcode_number: "#different", scratch_code: "#abc123"
      voucher.save!
    }.to raise_error(ActiveRecord::StatementInvalid)
  end

end