# frozen_string_literal: true
module Abilities
  class Guest
    include CanCan::Ability

    def initialize(user=nil)
      can    :read, :all
      cannot :read, ::Project, project_type: 'BusinessModel'
    end
  end
end
