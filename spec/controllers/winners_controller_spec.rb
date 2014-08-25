require "rails_helper"

describe WinnersController do

  before(:each) do
    store = Store.create name:"Cookie Jar"
    store = Store.create name:"Monkey Bar"
    store = Store.create name:"Donkey Car"
    user =  User.new(:email => 'mln@tws.com', :password => 'password', :password_confirmation => 'password', :name => "MLN Krishnan")
    user.save!
    sign_in user
  end

  it "should mark a voucher as winner" do
    cust = Customer.new(name: "Chobi", email: "chobi@goo.com", mobile: "9611805469", address: "20, blah, blah", occupation: "Blah", gender: "M", age: 78)
    transaction = cust.transactions.new date:'2012-03-14'
    cust.save!
    voucher = transaction.vouchers.new barcode_number: "#123abc"
    voucher.save

    post :create, :voucher => "#123abc"

    v = Voucher.first
    v.is_winner.should == true
  end

end
