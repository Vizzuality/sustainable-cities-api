# frozen_string_literal: true
module V1
  class BusinessModelsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'BusinessModel'

    def index
      jsonapi_render json: BusinessModel.where(owner_id: current_user.id)
    end

  end
end
