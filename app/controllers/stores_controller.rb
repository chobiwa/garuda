class StoresController < ApplicationController
  before_action :require_admin_login
  before_action :authenticate_user! 

  def show
     store_id = params[:id]
     @transaction_items = TransactionItem.where store_id: 84
     #@transaction = Transaction.find_by_id(@transaction_items.transaction_id)
     # @transaction = @transaction_items.transact
  end
end