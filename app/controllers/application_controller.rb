# frozen_string_literal: true
require 'oj'

class ApplicationController < ActionController::API
  before_action :check_access, :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: [{ status: '401', title: exception.message }] }, status: 401
  end

  def valid_api_key?
    !!web_user
  end

  def logged_in?
    !!current_user
  end

  def web_user
    if api_key_present?
      user = User.find(api_auth['user'])
      if user && user.api_key_exists?
        @current_api_user ||= user
      end
    end
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

    def check_access
      render json: { errors: [{ status: '401', title: 'Sorry invalid API token' }] }, status: 401 unless valid_api_key?
    end

    def authenticate
      render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401 unless logged_in?
    end

    def record_not_found
      render json: { errors: [{ status: '404', title: 'Record not found' }] }, status: 404
    end

    def token
      request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
    end

    def api_key
      request.env['SC_API_KEY'].scan(/Bearer (.*)$/).flatten.last
    end

    def auth
      Auth.decode(token)
    end

    def api_auth
      Auth.decode(api_key)
    end

    def api_key_present?
      !!request.env.fetch('SC_API_KEY', '').scan(/Bearer/).flatten.first
    end

    def auth_present?
      !!request.env.fetch('HTTP_AUTHORIZATION', '').scan(/Bearer/).flatten.first
    end
end
