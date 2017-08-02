# frozen_string_literal: true
module V1
  class CitiesController < ApplicationController
    include ErrorSerializer
    include ApiUploads

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'City'

    before_action :set_city, only: [:show, :update, :destroy]

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
        return_params = params.require(:city).permit(:name, :country_id, :is_featured, :iso, :lat, :lng, :province,
                                     { photos_attributes: [:id, :name, :attachment, :is_active, :_destroy] })

        if return_params[:photos_attributes].present?
          return_params[:photos_attributes].each do |photo_attributes|
            photo_attributes[:attachment] = process_file_base64(photo_attributes[:attachment].to_s) if photo_attributes[:attachment].present?
          end
        end

        return_params
      end
  end
end
