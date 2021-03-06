# frozen_string_literal: true
module Abilities
  class Admin
    include CanCan::Ability

    def initialize(user)
      can :manage, :all

      cannot :destroy,                 ::User, id: user.id
      cannot [:activate, :deactivate], ::User, id: user.id
    end
  end
end
