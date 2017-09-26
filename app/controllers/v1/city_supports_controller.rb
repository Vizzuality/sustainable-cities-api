# frozen_string_literal: true
module V1
  class CitySupportsController < ApplicationController
    include ErrorSerializer
    include ApiUploads

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'CitySupport'

    before_action :set_city_support, only: [:show, :update, :destroy]

    def index
      city_supports = CitySupportsIndex.new(self)
      render json: city_supports.city_supports, each_serializer: CitySupportSerializer, include: [:photos],
             links: city_supports.links, meta: { total_items: city_supports.total_items }
    end

    def show
      render(
        json: @city_support,
        serializer: CitySupportSerializer,
        include: [:photos],
        meta: { updated_at: @city_support.updated_at, created_at: @city_support.created_at },
      )
    end

    def update
      if @city_support.update(city_support_params)
        render json: { messages: [{ status: 200, title: "City support successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@city_support.errors, 422), status: 422
      end
    end

    def create
      @city_support = CitySupport.new(city_support_params)
      if @city_support.save
        render json: { messages: [{ status: 201, title: 'City support successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@city_support.errors, 422), status: 422
      end
    end

    def destroy
      if @city_support.destroy
        render json: { messages: [{ status: 200, title: 'City support successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@city_support.errors, 422), status: 422
      end
    end

    private

      def set_city_support
        @city_support = CitySupport.find(params[:id])
      end

      def city_support_params
        return_params = params.require(:city_support).permit(:title, :description, :date, { photos_attributes: [:id, :name, :attachment, :is_active, :_destroy] })

        process_attachments_in(return_params, :photos_attributes)
        process_attachments_in(return_params, :documents_attributes)

        return_params
      end
  end
end
