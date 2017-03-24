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
      role.in?('editor')
    end

    def user?
      role.in?('user')
    end

    def is_active_admin?
      admin? && is_active?
    end

    def is_active_publisher?
      publisher? && is_active?
    end

    def is_active_editor?
      editor? && is_active?
    end

    def is_active_user?
      user? && is_active?
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
