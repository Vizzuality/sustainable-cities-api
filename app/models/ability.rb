# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    case user
    when user.is_active_admin?     then merge Abilities::Admin.new(user)
    when user.is_active_publisher? then merge Abilities::Publisher.new(user)
    when user.is_active_editor?    then merge Abilities::Editor.new(user)
    when user.is_active_user?      then merge Abilities::User.new(user)
    else
      merge Abilities::Guest.new(user)
    end
  end
end
