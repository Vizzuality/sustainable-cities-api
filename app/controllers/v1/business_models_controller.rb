# frozen_string_literal: true
module V1
  class BusinessModelsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'BusinessModel'

    before_action :set_business_model, only: [:update, :destroy]
    # before_action :set_business_model, only: [:show]
    # before_action :set_business_model_edit, only: [:update, :destroy]

    def update
      if @business_model.update(business_model_params)
        @business_model.users << current_user unless @business_model.users.include?(current_user)
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

      def set_business_model
        @business_model = BusinessModel.find(params[:id])
      end

      # def set_business_model
      #   @business_model = BusinessModel.find_by(link_share: params[:id])
      # end

      # def set_business_model_edit
      #   @business_model = BusinessModel.find_by(link_edit: params[:id])
      # end

      def business_model_params
        return_params = params.require(:business_model).permit(:title, :description, :solution_id, { bme_ids: [] }, { enabling_ids: [] })
        return_params[:owner_id] = current_user.id

        return_params
      end
  end
end
