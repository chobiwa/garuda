class CustomersController < ApplicationController
  before_action :require_admin_login

  def show
    mobile = params[:id]
    c = Customer.find_by_mobile(mobile)
    if(c.nil?)
      render :nothing => true, :status => :not_found
      return
    end
    json = c.to_json ({:methods => :is_winner?})
    render :json => json
  end

  def index
    @customers = Customer.all
    respond_to do |format|
      format.html
      format.csv { send_data @customers.to_csv }
    end
  end
end