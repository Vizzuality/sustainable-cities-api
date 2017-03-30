# frozen_string_literal: true
module V1
  class CitiesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'City'

    before_action :set_city, only: [:show, :update, :destroy]

    def index
      @cities = CitiesIndex.new(self)
      render json: @cities.cities, each_serializer: CitySerializer, links: @cities.links
    end

    def show
      render json: @city, serializer: CitySerializer, meta: { updated_at: @city.updated_at, created_at: @city.created_at }
    end

    def update
      if @city.update(city_params)
        render json: { messages: [{ status: 200, title: "City successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@city.errors, 422), status: 422
      end
    end

    def create
      @city = City.new(city_params)
      if @city.save
        render json: { messages: [{ status: 201, title: 'City successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@city.errors, 422), status: 422
      end
    end

    def destroy
      if @city.destroy
        render json: { messages: [{ status: 200, title: 'City successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@city.errors, 422), status: 422
      end
    end

    private

      def set_city
        @city = City.find(params[:id])
      end

      def city_params
        params.require(:city).permit(:name, :country_id, :iso, :lat, :lng, :province)
      end
  end
end
