# frozen_string_literal: true
module Abilities
  class User
    include CanCan::Ability

    def initialize(user)
      can :read, :all
      cannot :read, ::Contact
      can    :create, ::Contact
      can :read, ::Project, project_type: 'StudyCase'

      can [:index_all, :show_project_and_bm], ::Project, project_users: { user_id: user.id }

      can :update, ::User,    id: user.id
      can :update, ::Project, project_users: { user_id: user.id }
      can :create, ::Comment

      can :create, ::BusinessModel
      can :update, ::BusinessModel
      can :delete, ::BusinessModel, owner_id: user.id

      cannot :read, ::Comment
    end
  end
end
