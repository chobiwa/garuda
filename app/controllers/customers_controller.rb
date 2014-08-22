class CustomersController < ApplicationController

  def show
    mobile = params[:id]
    c = Customer.find_by_mobile(mobile)
    if(c.nil?)
      render :nothing => true, :status => :not_found
      return
    end
    render :json => c
  end
end