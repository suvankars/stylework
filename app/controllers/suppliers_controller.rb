class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.all
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    @contact = Contact.new
    @address = Address.new
    @finance = Finance.new
  end

  def edit
    @contact = Contact.new if @contact.nil?
    @address = Address.new if @addresses.empty?
    @finance = Finance.new if @finance.nil?
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)
    #supplier_contact = @supplier.build_contact(contact_params)  
    #@address = @supplier.address.new() 
   
    #supplier_finance = @supplier.create_finance(finance_params)
    respond_to do |format|
      if @supplier.save #supplier_contact.save #and supplier_address.save and supplier_finance.save

        format.html { redirect_to registration_steps_path(supplier_id: @supplier)}
        #format.html { redirect_to @supplier, notice: 'Supplier was successfully created.' }
      else
        format.html { render :new }
      end
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

  def update_finance
    if !@finance.nil?
      @finance.update(finance_params)
    end
  end

  def update_address
    @address = Address.find(params[:address][:id])

    if @supplier.address.nil?
      address = @supplier.address.new(address_params)
      address.save
    else
      @address.update(address_params)
    end
  end
  
  def update
    respond_to do |format|
      #if @supplier.update(supplier_params) and update_contact and update_address and update_finance
       if @supplier.update(supplier_params)
        format.html { redirect_to registration_steps_path(supplier_id: @supplier)}
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'Supplier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
      @contact = @supplier.contact
      @addresses = @supplier.address.all
      @finance = @supplier.finance
    end

    def supplier_params
      params.require(:supplier).permit(:company, :code, :status, :description)
    end

    def contact_params
      params.require(:contact).permit(:email, :telephone, :fax, :mobile, :website, :skype, :supplier_id)
    end

    def address_params
      params.require(:address).permit(:name, :pincode, :address_line_1, :address_line_2, :city, :state, :country, :supplier_id)
    end

    def finance_params
      params.require(:finance).permit(:price_list, :currency, :tax_code, :email, :registration_number, :payment_method, :credit_limit, :credit_lead_time , :bank_name, :account_number, :IFSC_code)
    end
end

