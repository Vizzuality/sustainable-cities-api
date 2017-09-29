# frozen_string_literal: true
module V1
  class CitySupportCategoriesController < ApplicationController
    def index
      categories = CitySupportCategory.all
      render json: categories, each_serializer: CitySupportCategorySerializer
    end
  end
end