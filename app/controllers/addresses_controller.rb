class AddressesController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to [@supplier, @contact] , notice: 'Address was successfully updated.'
    else
      redder :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to suppliers_url, notice: 'Contact was successfully destroyed.' 
  end

  private

  def set_contact
    @supplier = Supplier.find(params[:supplier_id])
    @addresses = @supplier.address.all
    @address = Address.find(params[:id])
  end

  def address_params
      params.require(:address).permit(:name, :pincode, :address_line_1, :address_line_2, :city, :state, :country, :supplier_id)
  end
end
