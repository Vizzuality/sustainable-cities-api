# frozen_string_literal: true
module V1
  class ContactsController < ApplicationController
    include ErrorSerializer

    load_and_authorize_resource class: 'Contact'
    skip_before_action :authenticate, only: :create

    def create
      @contact = Contact.new(contact_params)
      if @contact.save
        ContactMailer.contact_email(@contact.email).deliver_now!
        render json: { messages: [{ status: 201, title: 'Contact successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@contact.errors, 422), status: 422
      end
    end

    private

    def contact_params
      params.require(:contact).permit(:name, :email)
    end
  end
end
