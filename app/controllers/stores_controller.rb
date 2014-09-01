class StoresController < ApplicationController
  before_action :require_admin_login
  before_action :authenticate_user! 

  def show
     store_id = params[:id]
     @transaction_items = TransactionItem.where store_id: store_id
  end
end