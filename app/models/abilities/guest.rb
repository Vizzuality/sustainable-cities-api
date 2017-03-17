# frozen_string_literal: true
module Abilities
  class Guest
    include CanCan::Ability

    def initialize(user)
      can :update, ::User, id: user.id
    end
  end
end
