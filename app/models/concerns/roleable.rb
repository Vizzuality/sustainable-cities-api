# frozen_string_literal: true
module Roleable
  extend ActiveSupport::Concern

  included do
    def admin?
      role.in?('admin')
    end

    def publisher?
      role.in?('publisher')
    end

    def editor?
      user_permission.user_role.in?('editor')
    end

    def user?
      role.in?('user')
    end

    def role_name
      case role
      when 'admin'     then 'Admin'
      when 'publisher' then 'Publisher'
      when 'editor'    then 'Editor'
      else
        'User'
      end
    end
  end

  class_methods do
  end
end
