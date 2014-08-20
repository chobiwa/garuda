require "rails_helper"

describe Voucher, :type => :model do

  it "should create a Voucher" do

  	Voucher.create barcode_number: "#123abc", scratch_code: "#abc123"

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 1

  	expected_voucher = all_vouchers.first

  	expected_voucher.barcode_number.should == '#123abc'
  	expected_voucher.scratch_code.should == '#abc123'

  end

  it "should ensure presence of barcode_number" do

  	Voucher.create barcode_number: "", scratch_code: "#abc123"

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 0

  end

  it "should ensure presence of scratch_code" do

  	Voucher.create barcode_number: "#abc123", scratch_code: nil

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 0

  end

  it "should ensure uniqueness of barcode_number" do

  	Voucher.create barcode_number: "#123abc", scratch_code: "#abc123"

  	expect {
  	Voucher.create barcode_number: "#123abc", scratch_code: "#abc124"
  	}.to raise_error(ActiveRecord::RecordNotUnique)

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 1

  	expected_voucher = all_vouchers.first

  	expected_voucher.barcode_number.should == '#123abc'
  	expected_voucher.scratch_code.should == '#abc123'

  end


  it "should ensure uniqueness of scratch_code" do

  	Voucher.create barcode_number: "#123abc", scratch_code: "#abc123"

  	expect {
  	Voucher.create barcode_number: "#124abc", scratch_code: "#abc123"
  	}.to raise_error(ActiveRecord::RecordNotUnique)

  	all_vouchers = Voucher.all
  	all_vouchers.length.should == 1

  	expected_voucher = all_vouchers.first

  	expected_voucher.barcode_number.should == '#123abc'
  	expected_voucher.scratch_code.should == '#abc123'

  end


end

