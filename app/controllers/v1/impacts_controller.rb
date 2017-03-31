# frozen_string_literal: true
module V1
  class ImpactsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Impact'

    before_action :set_impact, only: [:show, :update, :destroy]

    def index
      @impacts = ImpactsIndex.new(self)
      render json: @impacts.impacts, each_serializer: ImpactSerializer, links: @impacts.links
    end

    def show
      render json: @impact, serializer: ImpactSerializer, include: [:external_sources], meta: { updated_at: @impact.updated_at,
                                                                                                created_at: @impact.created_at }
    end

    def update
      if @impact.update(impact_params)
        render json: { messages: [{ status: 200, title: "Impact successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@impact.errors, 422), status: 422
      end
    end

    def create
      @impact = Impact.new(impact_params)
      if @impact.save
        render json: { messages: [{ status: 201, title: 'Impact successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@impact.errors, 422), status: 422
      end
    end

    def destroy
      if @impact.destroy
        render json: { messages: [{ status: 200, title: 'Impact successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@impact.errors, 422), status: 422
      end
    end

    private

      def set_impact
        @impact = Impact.find(params[:id])
      end

      def impact_params
        set_impact_params = [:name, :description, :impact_value, :impact_unit, :project_id, :category_id]
        if @current_user.is_active_admin?
          set_impact_params << [:is_active]
        end

        params.require(:impact).permit(set_impact_params)
      end
  end
end
