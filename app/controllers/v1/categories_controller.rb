# frozen_string_literal: true
module V1
  class CategoriesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Category'

    before_action :set_category, only: [:show, :update, :destroy]

    def index
      @categories = CategoriesIndex.new(self)
      render json: @categories.categories, each_serializer: params['category_type'].match?('Tree') ? CategoryTreeSerializer : CategorySerializer,
             links: @categories.links, meta: { total_items: @categories.total_items }
    end

    def show
      render json: @category, serializer: CategorySerializer, meta: { updated_at: @category.updated_at, created_at: @category.created_at }
    end

    def update
      if @category.update(category_params)
        render json: { messages: [{ status: 200, title: "Category successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@category.errors, 422), status: 422
      end
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        render json: { messages: [{ status: 201, title: 'Category successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@category.errors, 422), status: 422
      end
    end

    def destroy
      if @category.destroy
        render json: { messages: [{ status: 200, title: 'Category successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@category.errors, 422), status: 422
      end
    end

    private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :category_type, :parent_id, :label)
      end
  end
end
