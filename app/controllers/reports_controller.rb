class ReportsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @transactions = Transaction.where("date > ?", Date.today)
    @no_of_transactions = @transactions.length
    @no_of_coupons = @transactions.map{|t| t.vouchers_length}.inject{|total, vl| total+vl}
    @total_amount = @transactions.map{|t| t.total_amount}.inject{|total, vl| total+vl}
  end
end