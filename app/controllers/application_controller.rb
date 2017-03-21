# frozen_string_literal: true
require 'oj'

class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: [{ status: '401', title: exception.message }] }, status: 401
  end

  def logged_in?
    !!current_user
  end

  def current_user
    if auth_present?
      user = User.find(auth['user'])
      if user
        @current_user ||= user
      end
    end
  end

  protected

    def authenticate
      render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401 unless logged_in?
    end

    def record_not_found
      render json: { errors: [{ status: '401', title: 'Record not found' }] }, status: 401
    end

    def token
      request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
    end

    def auth
      Auth.decode(token)
    end

    def auth_present?
      !!request.env.fetch('HTTP_AUTHORIZATION', '').scan(/Bearer/).flatten.first
    end
end
