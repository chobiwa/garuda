require "rails_helper"

describe TransactionsController do
  
  it "Creates a transaction with one receipt" do

    post :create, '{"receiptInfo":[{"storeName":"StoreName","amount":"1000","billNo":"AWE","isToday":false}],"customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},"voucherInfo":[{"barCode":"QWEEW","scratchCode":"YUUI"}]}'

    Customer.all.length.should == 1
    customer = Customer.first
    customer.name.should == "MLN"
    customer.mobile.should == "9887887878"
    customer.email.should == "mln@tw.cc"
    customer.address.should == "12, B Main, elsewhere"
    customer.occupation.should == "Dev"
    customer.gender.should == "M"
    customer.age.should == 112

    customer.transactions.length.should == 1
    transaction = customer.transactions.first
    transaction.customer.should == customer
    transaction.date.should == Date.today

    transaction.transaction_items.length.should == 1
    transaction_item = transaction.transaction_items.first
    transaction_item.transact.should == transaction
    transaction_item.item_id.should == "AWE"
    transaction_item.store.should == Store.first
    transaction_item.amount.should == 1000
    transaction_item.date.should   ==  Date.today

    transaction.vouchers.length.should == 1
    voucher = transaction.vouchers.first
    voucher.barcode_number.should == "QWEEW"
    voucher.scratch_code.should == 'YUUI'
  end


  

end