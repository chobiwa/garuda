class VouchersController < ApplicationController
  before_action :require_admin_login

  def index
    @vouchers = Voucher.all
    respond_to do |format|
      format.html
      format.csv { send_data @vouchers.to_csv }
    end
  end
end