# frozen_string_literal: true
module V1
  class ProjectsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Project'

    before_action :set_project, only: [:show, :update, :destroy]

    def index
      @projects = ProjectsIndex.new(self)
      render json: @projects.projects, each_serializer: ProjectSerializer, include: ['category', 'country', 'cities', 'users',
                                                                                     'bmes', 'photos', 'documents', 'external_sources',
                                                                                     'comments', 'impacts'], links: @projects.links
    end

    def show
      render json: @project, serializer: ProjectSerializer, meta: { updated_at: @project.updated_at, created_at: @project.created_at }
    end

    def update
      if @project.update(project_params)
        render json: { messages: [{ status: 200, title: "Project successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@project.errors), status: 422
      end
    end

    def create
      @project = Project.new(project_params)
      if @project.save
        render json: { messages: [{ status: 201, title: 'Project successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@project.errors), status: 422
      end
    end

    def destroy
      if @project.destroy
        render json: { messages: [{ status: 200, title: 'Project successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@project.errors), status: 422
      end
    end

    private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:id, :name, :situation, :solution, :category_id, :country_id,
                                        :operational_year, :project_type, :is_active)
      end
  end
end
