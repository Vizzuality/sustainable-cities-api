# frozen_string_literal: true
module V1
  class CurrentUserController < ApplicationController
    include ErrorSerializer

    def show
      render json: current_user, serializer: UserSerializer
    end
  end
end
