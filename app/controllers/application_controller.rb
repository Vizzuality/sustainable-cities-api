# frozen_string_literal: true
require 'oj'

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: [{ status: '401', title: exception.message }] }, status: 401
  end

  protected

    def record_not_found
      render json: { errors: [{ status: '404', title: 'Record not found' }] }, status: 404
    end
end
