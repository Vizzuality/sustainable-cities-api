# frozen_string_literal: true
module V1
  class ProjectsController < ApplicationController
    include ErrorSerializer
    include ApiUploads

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Project'

    before_action :set_project,      only: [:update, :destroy]

    def update
      if @project.update(project_params)
        render json: { messages: [{ status: 200, title: "Project successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@project.errors, 422), status: 422
      end
    end

    def create
      @project = Project.new(project_params)
      if @project.save
        render json: { messages: [{ status: 201, title: 'Project successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@project.errors, 422), status: 422
      end
    end

    def destroy
      if @project.destroy
        render json: { messages: [{ status: 200, title: 'Project successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@project.errors, 422), status: 422
      end
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      return_params = params.require(:project).permit(:name, :situation, :solution, :category_id, :project_type, :tagline,
                                                      { comments_attributes: [:id, :body, :is_active, :user_id, :_destroy] },
                                                      { project_bmes_attributes: [:id, :bme_id, :description, :_destroy] },
                                                      :country_id, :operational_year, { user_ids: [] }, { city_ids: [] },
                                                      { external_source_ids: [] }, { photo_ids: [] },
                                                      { document_ids: [] },
                                                      { impacts_attributes: [:id, :name, :description, :impact_value,
                                                                             :impact_unit, :categoy_id, :is_active,
                                                                             :_destroy, { external_sources_index: [] },
                                                                             { remove_external_sources: [] }] },
                                                      { photos_attributes: [:id, :name, :attachment, :is_active, :_destroy] },
                                                      { documents_attributes: [:id, :name, :attachment, :is_active, :_destroy] },
                                                      { external_sources_attributes: [:id, :name, :description, :web_url, :source_type,
                                                                                      :author, :publication_year, :institution, :is_active, :_destroy] })

      return_params[:user_ids] = params[:project][:user_ids] if @current_user.is_active_admin?
      return_params[:user_ids] = [@current_user.id]          if :create && return_params[:user_ids].blank?
      if @current_user.is_active_admin? || @current_user.is_active_publisher?
        return_params[:is_active]   = params[:project][:is_active] if params[:project][:is_active]
        return_params[:is_featured] = params[:project][:is_featured] if params[:project][:is_featured]
      else
        return_params[:is_active]   = false
        return_params[:is_featured] = false
      end

      if @current_user.is_active_admin?
        return_params[:project_type] = params[:project][:project_type] if params[:project][:project_type]
      elsif :create && (@current_user.is_active_editor? || @current_user.is_active_publisher?)
        if params[:project][:project_type].include?('BusinessModel')
          return_params[:project_type] = params[:project][:project_type]
        else
          render json: { errors: [{ status: '401', title: 'Unauthorized to create a study case.' }] }, status: 401
        end
      end

      if return_params[:photos_attributes].present?
        return_params[:photos_attributes].each do |photo_attributes|
          photo_attributes[:attachment] = process_file_base64(photo_attributes[:attachment].to_s) if photo_attributes[:attachment].present?
        end
      end

      if return_params[:documents_attributes].present?
        return_params[:documents_attributes].each do |document_attributes|
          document_attributes[:attachment] = process_file_base64(document_attributes[:attachment].to_s) if document_attributes[:attachment].present?
        end
      end

      return_params
    end
  end
end
