# frozen_string_literal: true
module Abilities
  class Publisher
    include CanCan::Ability

    def initialize(user)
      can :read, :all

      can [:activate, :deactivate], ::Comment
      can [:activate, :deactivate], ::Project
      can [:activate, :deactivate], ::User
      can [:activate, :deactivate], ::Photo
      can [:activate, :deactivate], ::Document
      can [:activate, :deactivate], ::ExternalSource
      can [:activate, :deactivate], ::Country
      can [:activate, :deactivate], ::Impact
      can [:publish, :unpublish],   ::Project

      can :manage, ::Project, project_users: { user_id: user.id, is_owner: true }
      can :update, ::Project, project_users: { user_id: user.id                 }
      can :update, ::User,    id: user.id

      cannot [:activate, :deactivate], ::User, id: user.id
    end
  end
end
