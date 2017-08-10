# frozen_string_literal: true
module V1
  class BusinessModelsController < ApplicationController
    include ErrorSerializer
    include JSONAPI::Utils

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'BusinessModel'

    # before_action :set_business_model, only: [:update, :destroy]
    # before_action :set_business_model, only: [:show]
    before_action :set_business_model_edit, only: [:update, :destroy]

    def index
      # Only for current user
    end

    def show
      jsonapi_render json: (BusinessModel.find_by(link_share: params[:id]) || BusinessModel.find_by(link_edit: params[:id]))
    end

    def update
      if @business_model.update(business_model_params)
        @business_model.users << current_user unless @business_model.users.include?(current_user)
        render json: { messages: [{ status: 200, title: "Business Model successfully updated!" }] }, status: 200
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
      def set_business_model_edit
        @business_model = BusinessModel.find_by(link_edit: params[:id])
      end

      def business_model_params
        return_params = params.require(:data)
                              .require(:attributes)
                              .permit(:title, :description, :'solution-id')

        return_params[:owner_id] = current_user.id

        return_params.keys.each {|k| return_params[k.gsub('-', '_')] = return_params[k]; return_params.delete(k) if k.include?('-')}

        return_params
      end
  end
end
