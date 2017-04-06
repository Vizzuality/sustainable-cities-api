# frozen_string_literal: true
module V1
  class ProjectsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Project'

    before_action :set_full_project, only: [:show, :show_project_and_bm]
    before_action :set_project,      only: [:update, :destroy]

    def index
      render_projects
    end

    def index_all
      if (@current_user.is_active_admin? || @current_user.is_active_publisher?) ||
         (params[:business_models].present? && (@current_user.is_active_editor? || @current_user.is_active_user?))
        render_projects
      else
        render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401
      end
    end

    def show
      render_project
    end

    def show_project_and_bm
      render_project
    end

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

      def render_project
        render json: @project, serializer: ProjectSerializer, include: [:country,
                                                                        :category,
                                                                        :bmes,
                                                                        :impacts,
                                                                        :cities,
                                                                        :external_sources,
                                                                        :photos,
                                                                        :documents,
                                                                        :comments],
               meta: { updated_at: @project.updated_at, created_at: @project.created_at }
      end

      def render_projects
        @projects = ProjectsIndex.new(self, @current_user)
        render json: @projects.projects, each_serializer: ProjectSerializer, links: @projects.links
      end

      def set_project
        @project = Project.find(params[:id])
      end

      def set_full_project
        @project = Project.include_relations.find(params[:id])
      end

      def project_params
        params.require(:project)
        return_params = {
          name:                params[:project][:name],
          situation:           params[:project][:situation],
          solution:            params[:project][:solution],
          category_id:         params[:project][:category_id],
          country_id:          params[:project][:country_id],
          operational_year:    params[:project][:operational_year],
          city_ids:            params[:project][:city_ids],
          bme_ids:             params[:project][:bme_ids],
          external_source_ids: params[:project][:external_source_ids],
          impact_ids:          params[:project][:impact_ids]
        }

        return_params[:user_ids]  = params[:project][:user_ids]  if @current_user.is_active_admin?
        return_params[:user_ids]  = [@current_user.id]           if :create && return_params[:user_ids].blank?
        return_params[:is_active] = params[:project][:is_active] if @current_user.is_active_admin? || @current_user.is_active_publisher?

        if @current_user.is_active_admin?
          return_params[:project_type] = params[:project][:project_type]
        elsif :create && (@current_user.is_active_editor? || @current_user.is_active_publisher?)
          return_params[:project_type] = params[:project][:project_type] if params[:project][:project_type].include?('BusinessModel')
          render json: { errors: [{ status: '401', title: 'Unauthorized to create a study case.' }] }, status: 401 if return_params[:project_type].blank?
        end

        return_params
      end
  end
end
