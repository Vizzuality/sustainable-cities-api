# frozen_string_literal: true
module V1
  class PrivateCategoriesController < ApplicationController
    include ErrorSerializer
    include JSONAPI::Utils

    skip_before_action :authenticate, only: [:index]
    load_and_authorize_resource class: 'Category'

    def index
      jsonapi_render json: Category.unscope(where: :private)
    end
  end
end
