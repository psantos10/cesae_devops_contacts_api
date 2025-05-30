class ContactsController < ApplicationController
  before_action :set_contact, only: [ :show, :update, :destroy ]

  def index
    @contacts = Contact.all
  end

  def show
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      render :show, status: :created
    else
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      render :show, status: :ok
    else
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @contact.destroy
      head :no_content
    else
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone)
  end

  def set_contact
    @contact = Contact.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Contact not found" }, status: :not_found
  end
end
