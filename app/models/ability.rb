# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    if user # devise session users
      if user.is_active_admin?
        merge Abilities::Admin.new(user)
      elsif user.is_active_publisher?
        merge Abilities::Publisher.new(user)
      elsif user.is_active_editor?
        merge Abilities::Editor.new(user)
      else
        merge Abilities::User.new(user)
      end
    else
      merge Abilities::Guest.new
    end
  end
end
