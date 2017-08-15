# frozen_string_literal: true
module V1
  class BusinessModelEditsController < ApplicationController
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
        return_params = params.require(:business_model).permit(:title, :description, :owner_id, :solution_id, enabling_ids: [],
                                            business_model_bmes_attributes: [:id, :bme_id, :_destroy, comment_attributes: [:body, :user_id, :id, :_destroy],
                                                                              bme_attributes: [:id, :name, :private, :_destroy, category_ids: []]])

        return_params[:owner_id] = current_user.id

        if return_params["business_model_bmes_attributes"].present?
          return_params["business_model_bmes_attributes"].each do |bm_bme|
            bm_bme["comment_attributes"]["user_id"] = current_user.id if bm_bme["comment_attributes"].present?
            bm_bme["bme_attributes"]["private"] = true if bm_bme["bme_attributes"].present?
          end
        end

        return_params
      end

  end
end