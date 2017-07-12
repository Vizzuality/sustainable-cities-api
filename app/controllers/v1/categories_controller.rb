# frozen_string_literal: true
module V1
  class CategoriesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Category'

=begin
    def index
      filters = params[:filters]

      if filters.present?
        if filters[:type].present?
          filters = filters[:type].split(',') rescue ''
          @categories = Category.where(category_type: filters).select(:id, :name, :slug, :description, :category_type, :parent_id).second_level.group_by(&:category_type)

          if @categories.empty?
            raise ActiveRecord::RecordNotFound
          else
            render json: { data: @categories }
          end
        elsif filters[:bme].present?
          @bme = Category.where(category_type: 'Bme').find(filters[:bme])

          raise ActiveRecord::RecordNotFound unless @bme
          render json: @bme, serializer: BmeCategorySerializer
        end
      end
    end
=end

  end
end
