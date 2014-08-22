class TransactionsController < ApplicationController
  def new
  end

  # {"receiptInfo"=>[{"storeName"=>"StoreName", "amount"=>"1000", "billNo"=>"AWE", "isToday"=>false}], "customerInfo"=>{"mobile"=>"9887887878", "name"=>"MLN", "email"=>"mln@tw.cc", "gender"=>"M", "age"=>"112", "occupation"=>"Dev", "address"=>"12, B Main, elsewhere"}, "voucherInfo"=>[{"barCode"=>"QWEEW", "scratchCode"=>"YUUI"}]}
  def create
    body = JSON.parse(request.body.read)

    customer_info = body["customerInfo"] 
    receipt_info = body["receiptInfo"][0]
    voucher_info = body["voucherInfo"][0] 

    customer = Customer.new(name: customer_info["name"], email: customer_info["email"], mobile: customer_info["mobile"], address: customer_info["address"], occupation: customer_info["occupation"], gender: customer_info["gender"], age: customer_info["age"])
    transaction = customer.transactions.new date: Date.today
    store = Store.new(name:receipt_info["storeName"])
    receipt = transaction.transaction_items.new(item_id: receipt_info["billNo"], store: store, amount: receipt_info["amount"]         , date: Date.today)
    voucher = transaction.vouchers.new(barcode_number: voucher_info["barCode"], scratch_code: voucher_info["scratchCode"])

    customer.save!

    
    render :nothing => true
  end
end