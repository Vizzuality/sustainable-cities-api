# frozen_string_literal: true
module Abilities
  class User
    include CanCan::Ability

    def initialize(user)
      can :update, ::User,    id: user.id
      can :update, ::Project, project_users: { user_id: user.id }
    end
  end
end
