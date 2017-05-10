# frozen_string_literal: true
module V1
  class ExternalSourcesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'ExternalSource'

    before_action :set_external_source, only: [:show, :update, :destroy]

    def index
      external_sources = ExternalSourcesIndex.new(self)
      render json: external_sources.external_sources, each_serializer: ExternalSourceSerializer,
             links: external_sources.links, meta: { total_items: external_sources.total_items }
    end

    def show
      render json: @external_source, serializer: ExternalSourceSerializer,
             meta: { updated_at: @external_source.updated_at, created_at: @external_source.created_at }
    end

    def update
      if @external_source.update(external_source_params)
        render json: { messages: [{ status: 200, title: 'External Source successfully updated!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@external_source.errors, 422), status: 422
      end
    end

    def create
      external_source = ExternalSource.new(external_source_params)
      if external_source.save
        render json: { messages: [{ status: 201, title: 'External Source successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(external_source.errors, 422), status: 422
      end
    end

    def destroy
      if @external_source.destroy
        render json: { messages: [{ status: 200, title: 'External Source successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@external_source.errors, 422), status: 422
      end
    end

    private

    def set_external_source
      @external_source = ExternalSource.find(params[:id])
    end

    def external_source_params
      params.require(:external_source).permit(:name, :description, :web_url, :source_type, :author,
                                              :publication_year, :institution, :attacheable_type,
                                              :attacheable_id, :is_active)
    end
  end
end
