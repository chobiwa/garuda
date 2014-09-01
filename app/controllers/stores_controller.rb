class StoresController < ApplicationController
  before_action :require_admin_login
  before_action :authenticate_user! 

  def show
     store_id = params[:id]
     @store = Store.find_by_id(store_id)
     if(@store.nil?)
      render :nothing => true, :status => :not_found
      return
    end
     @transaction_items = TransactionItem.where store_id: store_id
  end
end