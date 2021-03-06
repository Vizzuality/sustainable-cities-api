# frozen_string_literal: true
module V1
  class ExternalSourcesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'ExternalSource'

    before_action :set_external_source, only: [:update, :destroy]

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
                                              :publication_year, :institution, :is_active)
    end
  end
end
