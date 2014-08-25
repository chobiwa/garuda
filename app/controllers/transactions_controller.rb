class TransactionsController < ApplicationController
  before_action :authenticate_user! 
  def new
    @stores = Store.all.map {|s| s.name}
  end

  def create
    body = JSON.parse(request.body.read)

    customer_info = body["customerInfo"] 
    receipt_info = body["receiptInfo"]
    voucher_info = body["voucherInfo"]
    voucher_info = voucher_info.nil? ? [] : voucher_info

    total_receipt_value = receipt_info
                          .map{|h| h["amount"].to_i}
                          .inject{|total, val| total+val}

    if(total_receipt_value < 1000)
       render :nothing => true, :status => :bad_request
       return
    end


    customer = Customer.find_by_mobile(customer_info["mobile"])
    if(customer.nil?)
      customer = Customer.new(name: customer_info["name"], email: customer_info["email"], mobile: customer_info["mobile"], address: customer_info["address"], occupation: customer_info["occupation"], gender: customer_info["gender"], age: customer_info["age"])
    else
      customer.name = customer_info["name"]
      customer.email = customer_info["email"]
      customer.address = customer_info["address"]
      customer.occupation = customer_info["occupation"]
      customer.gender = customer_info["gender"]
      customer.age = customer_info["age"]
    end


    if(customer.is_winner? and !voucher_info.empty?)
      render :nothing => true, :status => :bad_request
      return
    end

    if(not customer.is_winner?)
      no_of_vouchers_to_issue = total_receipt_value / 1000

      if(voucher_info.length != no_of_vouchers_to_issue)
        render :nothing => true, :status => 400
        return
      end
    end

    transaction = customer.transactions.new date:Date.today
    receipt_info.each do |receipt|
      store = Store.find_by_name(receipt["storeName"])
      if(store.nil?)
        render :nothing => true, :status => 400
        return
      end
      transaction.transaction_items.new(item_id: receipt["billNo"], store: store, amount: receipt["amount"], date: Date.today)
    end
    
    voucher_info.each do |voucher|
      transaction.vouchers.new(barcode_number: voucher["barCode"])
    end

    begin
      customer.save!  
    rescue ActiveRecord::RecordInvalid => e
      errors = []
      
      transaction.transaction_items.each do |ti|
        ti.errors.to_a.each do |e|
          if(e == "Item Receipt Taken")
            errors << "Dupliacte Receipt #{ti.item_id}"
          end
        end
      end

      render  :json => errors, :status => :bad_request
      return
    end
    

    flash[:notice] = "Transaction saved."    
    render :nothing => true
  end
end