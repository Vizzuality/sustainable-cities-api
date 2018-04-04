# frozen_string_literal: true
module V1
  class ContactUsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: :create

    def create
      contact_us = contact_us_params
      if contact_us[:name].present? && contact_us[:email].present?
        ContactUsMailer.contact_us_email(contact_us[:name],
                                         contact_us[:email],
                                         contact_us[:message]).deliver_now!
        render json: { messages: [{ status: 201, title: 'Email sent!' }] }, status: 201
      else
        render json: { errors: 'Please fill all the fields' }, status: 422
      end
    end

    private

    def contact_us_params
      params.require(:contact).permit(:name, :email, :message)
    end
  end
end