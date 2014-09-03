class CustomersController < ApplicationController
  before_action :require_admin_login, only: :index
  before_action :authenticate_user! 


  def show
    mobile = params[:id]
    @c = Customer.find_by_mobile(mobile)
    if(@c.nil?)
      flash[:error] = "Customer doesn't exist"
      redirect_to customers_path 
      return
    end
    @t = @c.transactions
    respond_to do |format|
      format.json do
        json = @c.to_json ({:methods => :is_winner?})
        render :json => json
      end
      format.html do
      
      end
    end
  end

  def index
    @customers = Customer.all.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.csv { send_data @customers.to_csv }
    end
  end
end