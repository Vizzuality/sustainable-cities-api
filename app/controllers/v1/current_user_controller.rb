# frozen_string_literal: true
module V1
  class CurrentUserController < ApplicationController
    include ErrorSerializer

    load_and_authorize_resource class: 'User'

    def show
      render json: current_user, serializer: UserSerializer
    end
  end
end
