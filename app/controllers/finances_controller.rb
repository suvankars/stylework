class FinancesController < ApplicationController
  before_action :set_finance, only: [:show, :edit, :update, :destroy]

  def edit
  end

  def update
    if @finance.update(finance_params)
      redirect_to [@supplier, @contact] , notice: "Financial information is updated successfully"
    end
  end

  def destroy

    @finance.destroy if !@finance.nil?
    redirect_to supplier_url(@supplier), notice: "Financial information deleted successfully"
  end

  private

  def set_finance
    @supplier = Supplier.find(params[:supplier_id])
    @finance = @supplier.finance
  end 

  #Repeted code, supplier controller
  def finance_params
      params.require(:finance).permit(:price_list, :currency, :tax_code, :email, :registration_number, :payment_method, :credit_limit, :credit_lead_time , :bank_name, :account_number, :IFSC_code)
  end
end
