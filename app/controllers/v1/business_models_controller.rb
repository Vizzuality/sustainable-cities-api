# frozen_string_literal: true
module V1
  class BusinessModelsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'BusinessModel'

    before_action :set_enabling, only: [:update, :destroy]

    def update
      if @business_model.update(business_model_params)
        render json: { messages: [{ status: 200, title: "Business Model successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@business_model.errors, 422), status: 422
      end
    end

    def create
      @business_model = BusinessModel.new(business_model_params)
      if @business_model.save
        render json: { messages: [{ status: 201, title: 'Business Model successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@business_model.errors, 422), status: 422
      end
    end

    def destroy
      if @business_model.destroy
        render json: { messages: [{ status: 200, title: 'Business Model successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@business_model.errors, 422), status: 422
      end
    end

    private

      def set_enabling
        @business_model = BusinessModel.find(params[:id])
      end

      def business_model_params
        params.require(:business_model).permit(:name, :description, :is_featured, :assessment_value, :category_id, { bme_ids: [] })
      end
  end
end
