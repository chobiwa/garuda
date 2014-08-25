class WinnersController < ApplicationController
  before_action :authenticate_user! 

  def new
  end

  def create
    voucher_barcode = params[:voucher]

    v = Voucher.find_by_barcode_number voucher_barcode 
    v.mark_as_winner
    v.save!
    
    redirect_to new_transaction_path
  end
end