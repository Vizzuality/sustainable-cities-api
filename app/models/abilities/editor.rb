# frozen_string_literal: true
module Abilities
  class Editor
    include CanCan::Ability

    def initialize(user)
      can :manage, ::Project, project_users: { user_id: user.id, is_owner: true }
      can :update, ::Project, project_users: { user_id: user.id                 }
      can :update, ::User,    id: user.id
    end
  end
end
