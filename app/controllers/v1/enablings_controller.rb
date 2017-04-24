# frozen_string_literal: true
module V1
  class EnablingsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Enabling'

    before_action :set_enabling, only: [:show, :update, :destroy]

    def index
      @enablings = EnablingsIndex.new(self)
      render json: @enablings.enablings, each_serializer: EnablingSerializer, links: @enablings.links, meta: { total_items: @enablings.total_items }
    end

    def show
      render json: @enabling, serializer: EnablingSerializer, meta: { updated_at: @enabling.updated_at, created_at: @enabling.created_at }
    end

    def update
      if @enabling.update(enabling_params)
        render json: { messages: [{ status: 200, title: "Enabling successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@enabling.errors, 422), status: 422
      end
    end

    def create
      @enabling = Enabling.new(enabling_params)
      if @enabling.save
        render json: { messages: [{ status: 201, title: 'Enabling successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@enabling.errors, 422), status: 422
      end
    end

    def destroy
      if @enabling.destroy
        render json: { messages: [{ status: 200, title: 'Enabling successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@enabling.errors, 422), status: 422
      end
    end

    private

      def set_enabling
        @enabling = Enabling.find(params[:id])
      end

      def enabling_params
        params.require(:enabling).permit(:name, :description, :assessment_value, :category_id, { bme_ids: [] })
      end
  end
end
