# frozen_string_literal: true
module V1
  class CurrentUserController < ApplicationController
    include ErrorSerializer

    load_and_authorize_resource class: 'User'

    def show
      render json: JSONAPI::ResourceSerializer.new(UserResource).serialize_to_hash(UserResource.new(current_user, current_user))
    end
  end
end
