require "rails_helper"

describe TransactionsController do

  before(:each) do
    store = Store.create name:"Cookie Jar"
    store = Store.create name:"Monkey Bar"
    store = Store.create name:"Donkey Car"
  end
  
  it "Creates a transaction with one receipt" do

    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"1000","billNo":"AWE","isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"QWEEW","scratchCode":"YUUI"}
                    ]}'

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
  
  it "Creates a transaction with multiple receipts" do

    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"500","billNo":"AWE1", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"400","billNo":"AWE2", "isToday":true},
                        {"storeName":"Donkey Car","amount":"100","billNo":"AWE3", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"QWEEW","scratchCode":"YUUI"}
                    ]}'

    Customer.all.length.should == 1
    customer = Customer.first
    customer.transactions.length.should == 1
    transaction = customer.transactions.first
    transaction.transaction_items.length.should == 3
    transaction.vouchers.length.should == 1
  end
  
  it "Creates a transaction with multiple vouchers" do

    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"1000","billNo":"1", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"1000","billNo":"2", "isToday":true},
                        {"storeName":"Donkey Car","amount":"1000","billNo":"3", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"1","scratchCode":"1"},
                        {"barCode":"2","scratchCode":"2"},
                        {"barCode":"3","scratchCode":"3"}
                    ]}'

    Customer.all.length.should == 1
    customer = Customer.first
    customer.transactions.length.should == 1
    transaction = customer.transactions.first
    transaction.transaction_items.length.should == 3
    transaction.vouchers.length.should == 3
  end
  
  it "Rejects if total receipt value is less than 1000" do
    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"100","billNo":"1", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"200","billNo":"2", "isToday":true},
                        {"storeName":"Donkey Car","amount":"699","billNo":"3", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"1","scratchCode":"1"},
                        {"barCode":"2","scratchCode":"2"},
                        {"barCode":"3","scratchCode":"3"}
                    ]}'

    expect(response).to have_http_status(:bad_request)

    Customer.all.length.should == 0
  end
  
  it "Fails when less vouchers are issued" do
    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"100","billNo":"1", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"1200","billNo":"2", "isToday":true},
                        {"storeName":"Donkey Car","amount":"1000","billNo":"3", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"1","scratchCode":"1"}
                    ]}'

    expect(response).to have_http_status(:bad_request)

    Customer.all.length.should == 0
  end
  
  it "Fails when more vouchers are issued" do
    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"100","billNo":"1", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"1200","billNo":"2", "isToday":true},
                        {"storeName":"Donkey Car","amount":"1000","billNo":"3", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"1","scratchCode":"1"},
                        {"barCode":"2","scratchCode":"2"},
                        {"barCode":"3","scratchCode":"3"},
                        {"barCode":"4","scratchCode":"4"},
                        {"barCode":"5","scratchCode":"5"}
                    ]}'

    expect(response).to have_http_status(:bad_request)

    Customer.all.length.should == 0
  end
  
  it "Attach new transaction to an existing customer" do

    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"1000","billNo":"1", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"1000","billNo":"2", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"1","scratchCode":"1"},
                        {"barCode":"2","scratchCode":"2"}
                    ]}'

    post :create, '{"receiptInfo":[
                        {"storeName":"Cookie Jar","amount":"1200","billNo":"3", "isToday":true},
                        {"storeName":"Monkey Bar","amount":"1020","billNo":"4", "isToday":true},
                        {"storeName":"Donkey Car","amount":"1000","billNo":"5", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"3","scratchCode":"3"},
                        {"barCode":"4","scratchCode":"4"},
                        {"barCode":"5","scratchCode":"5"}
                    ]}'

    Customer.all.length.should == 1
    customer = Customer.first
    customer.transactions.length.should == 2
    
    transaction = customer.transactions[0]
    transaction.transaction_items.length.should == 2
    transaction.vouchers.length.should == 2

    transaction = customer.transactions[1]
    transaction.transaction_items.length.should == 3
    transaction.vouchers.length.should == 3
  end

  it "Fails when unknown store is given" do

    post :create, '{"receiptInfo":[
                        {"storeName":"Monkey Bar","amount":"1000","billNo":"AWE3", "isToday":true},
                        {"storeName":"Donkey Tar","amount":"1000","billNo":"AWE3", "isToday":true}
                    ],
                    "customerInfo":{"mobile":"9887887878","name":"MLN","email":"mln@tw.cc","gender":"M","age":"112","occupation":"Dev","address":"12, B Main, elsewhere"},
                    "voucherInfo":[
                        {"barCode":"QWEEW","scratchCode":"YUUI"}
                    ]}'

    expect(response).to have_http_status(:bad_request)

    Customer.all.length.should == 0
  end

end