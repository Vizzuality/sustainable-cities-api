# frozen_string_literal: true
module Abilities
  class User
    include CanCan::Ability

    def initialize(user)
      can :read, :all
      can :read, ::Project, project_type: 'StudyCase'

      can [:index_all, :show_project_and_bm], ::Project, project_users: { user_id: user.id }

      can :update, ::User,    id: user.id
      can :update, ::Project, project_users: { user_id: user.id }
    end
  end
end
