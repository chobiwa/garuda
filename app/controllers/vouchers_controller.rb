class VouchersController < ApplicationController
  before_action :authenticate_user! 

  def index
    @vouchers = Voucher.all
    respond_to do |format|
      format.html
      format.csv { send_data @vouchers.to_csv }
    end
  end
end