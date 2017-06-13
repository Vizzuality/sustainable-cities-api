# frozen_string_literal: true
module V1
  class BmesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Bme'

    before_action :set_bme, only: [:show, :update, :destroy]

    def index
      bmes = BmesIndex.new(self)
      render json: bmes.bmes, each_serializer: BmeSerializer, include: [:categories, :enablings],
             links: bmes.links, meta: { total_items: bmes.total_items }
    end

    def show
      render json: @bme, serializer: BmeSerializer, include: [:categories, :enablings, :external_sources], meta: { updated_at: @bme.updated_at, created_at: @bme.created_at }
    end

    def update
      if @bme.update(bme_params)
        render json: { messages: [{ status: 200, title: "Business model element successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@bme.errors, 422), status: 422
      end
    end

    def create
      @bme = Bme.new(bme_params)
      if @bme.save
        render json: { messages: [{ status: 201, title: 'Business model element successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@bme.errors, 422), status: 422
      end
    end

    def destroy
      if @bme.destroy
        render json: { messages: [{ status: 200, title: 'Business model element successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@bme.errors, 422), status: 422
      end
    end

    private

      def set_bme
        @bme = Bme.find(params[:id])
      end

      def bme_params
        params.require(:bme).permit(:name, :description, :is_featured, { enabling_ids: [] }, { category_ids: [] },
                                    { external_sources_attributes: [:id, :name, :description, :web_url, :source_type,
                                                                    :author, :publication_year, :institution, :is_active, :_destroy] })
      end
  end
end
