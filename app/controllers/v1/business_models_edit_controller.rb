# frozen_string_literal: true
module V1
  class BusinessModelsEditController < ApplicationController
    include ErrorSerializer

    before_action :set_business_model, only: [:update, :destroy]

    def create
      authorize! :create, BusinessModel.new
      @business_model = BusinessModel.create(business_model_params)

      if !@business_model.errors.present?
        render json: { messages: [{
                                    status: 201, title: "Business Model successfully created!",
                                    link_share: @business_model.link_share,
                                    link_edit: @business_model.link_edit
                                  }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@business_model.errors, 422), status: 422
      end
    end

    def update
      authorize! :update, @business_model

      if @business_model.update(business_model_params)
        @business_model.users << current_user unless @business_model.users.include?(current_user)
        render json: { messages: [{ status: 200, title: "Business Model successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@business_model.errors, 422), status: 422
      end
    end

    def destroy
      authorize! :delete, @business_model

      if @business_model.destroy
        render json: { messages: [{ status: 200, title: 'Business Model successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@business_model.errors, 422), status: 422
      end
    end

    private

      def set_business_model
        @business_model = BusinessModel.find_by(link_edit: params[:id])
      end

      def business_model_params
        clean_params = params[:data][:attributes]
        clean_params[:owner_id] = current_user.id

        params[:data][:relationships].each do |k, value|
          clean_params.merge!({ "#{k}": value[:data] })
        end if params[:data][:relationships]

        clean_params.keys.each do |k|
          if k.include?('-')
            undescore_key = k.gsub('-', '_')
            clean_params[undescore_key] = clean_params[k]
            clean_params.delete(k)

            if clean_params[undescore_key].is_a?(Array)
              clean_params[undescore_key].first.transform_keys! { |key| key.underscore }
            end

            if k.split('-').last == "ids"
              clean_params[undescore_key] = clean_params[undescore_key].pluck(:id)
            end
          end
        end

        if clean_params[:business_model_bmes_attributes].present?
          if clean_params[:business_model_bmes_attributes].first[:comment_attributes].present?
            clean_params[:business_model_bmes_attributes].first[:comment_attributes][:user_id] = current_user.id
          end
        end

        clean_params["bmes_attributes"].each { |bme| bme["private"] = true } if clean_params["bmes_attributes"].present?

        return_params = clean_params.permit(:title, :description, :owner_id, :solution_id, enabling_ids: [],
                                            business_model_bmes_attributes: [:id, :bme_id, :_destroy, comment_attributes: [:body, :user_id, :id, :_destroy]],
                                            bmes_attributes: [:id, :name, :private, :_destroy, category_ids: []])

        return_params
      end

  end
end