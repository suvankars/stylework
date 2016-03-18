class RegistrationStepsController < ApplicationController
 include Wicked::Wizard
 before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  steps :address, :contact, :financial
  
  def show
    @supplier = Supplier.find(params[:supplier_id])
    #@address = @supplier.address.first.nil?? @supplier.address.new() : @supplier.address.first
    #@contact = Contact.new
    #@finance = Finance.new
    @contact = Contact.new if @contact.nil?
    @address = Address.new if @addresses.empty?
    @finance = Finance.new if @finance.nil?
    render_wizard
  end
  
  def update_address
    if @supplier.address.empty?
      address = @supplier.address.new(address_params)
      address.save
    else
      address = Address.find(params[:address][:id])
      address.update(address_params)
    end
  end

  def update_contact
    if @supplier.contact.nil?
      @contact = @supplier.build_contact(contact_params)
      @contact.save 
    else
      @contact.update(contact_params)
    end
  end

  def update
    @supplier = Supplier.find(params[:supplier_id])
    
    case step

    when :address
      @supplier = @supplier if update_address
    when :contact
      @supplier = @supplier if update_contact
    when :financial
      @supplier = @supplier.create_finance(finance_params)
        
    end
      
    render_wizard @supplier
  end

   private
    def set_supplier
      @supplier = Supplier.find(params[:supplier_id])
      @contact = @supplier.contact
      @addresses = @supplier.address.all
      @finance = @supplier.finance
    end


    def contact_params
      params.require(:contact).permit(:email, :telephone, :fax, :mobile, :website, :skype, :supplier_id)
    end

    def address_params
      params.require(:address).permit(:id, :name, :pincode, :address_line_1, :address_line_2, :city, :state, :country, :supplier_id)
    end

    def finance_params
      params.require(:finance).permit(:price_list, :currency, :tax_code, :email, :registration_number, :payment_method, :credit_limit, :credit_lead_time , :bank_name, :account_number, :IFSC_code)
    end

    def finish_wizard_path
      supplier_path(@supplier)#, notice: 'Supplier was successfully created.'
    end
end
