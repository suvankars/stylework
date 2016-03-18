class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def edit
  end

  def update
      if @contact.update(contact_params)
        redirect_to [@supplier, @contact] , notice: 'Contacts was successfully updated.'
      else
        render :edit 
      end
  end

  def show
  end

  # def new
  #   @supplier = Supplier.find(params[:supplier_id])
  #   p @supplier
  #   p @contact
  # end

  def destroy
    @contact.destroy
    redirect_to suppliers_url, notice: 'Contact was successfully destroyed.' 
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @supplier = Supplier.find(params[:supplier_id])
    @contact = @supplier.contact
  end

  def contact_params
    params.require(:contact).permit(:email, :telephone, :fax, :mobile, :website, :skype)
  end
end
