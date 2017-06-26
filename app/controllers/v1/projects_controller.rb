# frozen_string_literal: true
module V1
  class ProjectsController < ApplicationController
    include ErrorSerializer
    include ApiUploads

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Project'

    before_action :set_full_project, only: [:show, :show_project_and_bm]
    before_action :set_project,      only: [:update, :destroy]

    def index
      filters = params[:filters][:solution] rescue ''

      if filters.present?
        projects = filters == 'all' ? assemble_all_projects : assemble_filtered_projects(filters)
        sanitize_projects(projects)

        if projects.present?
          render json: { data: projects }
        else
          render json: { errors: [{ status: '404', title: 'Record not found' }] }, status: 404
        end
      else
        render_projects
      end
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

    def assemble_all_projects
      Category.by_type('Solution').second_level.map do |category|
        { "#{category.id}": category.children.map { |child| child.projects.select(:id, :name, :category_id) }.flatten }.stringify_keys
      end
    end

    def assemble_filtered_projects(filters)
      Category.find(filters).children.map do
        |category| category.projects.select(:id, :name, :category_id)
      end.map do |projects|
        projects.group_by(&:category_id)
      end
    end

    def sanitize_projects(projects)
      projects.each do |group|
        category = Category.find(group.keys.first)
        group['category_id'] = category.id
        group['name'] = category.name
        group['slug'] = category.slug
        group['projects'] = group.delete(group.keys.first)
      end
    end

    def render_project
      render json: @project, serializer: ProjectSerializer, include: [:country,
                                                                      [impacts: :category],
                                                                      [project_bmes: :bme],
                                                                      :cities,
                                                                      :external_sources,
                                                                      :photos,
                                                                      :documents,
                                                                      :comments],
             meta: { updated_at: @project.updated_at, created_at: @project.created_at }
    end

    def render_projects
      @projects = ProjectsIndex.new(self, @current_user)
      render json: @projects.projects, each_serializer: ProjectSerializer, links: @projects.links, meta: { total_items: @projects.total_items }
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def set_full_project
      @project = Project.include_relations.find(params[:id])
    end

    def project_params
      return_params = params.require(:project).permit(:name, :situation, :solution, :category_id, :project_type,
                                                      { comments_attributes: [:id, :body, :is_active, :user_id, :_destroy] },
                                                      { project_bmes_attributes: [:id, :bme_id, :description, :_destroy] },
                                                      :country_id, :operational_year, { user_ids: [] }, { city_ids: [] },
                                                      { external_source_ids: [] }, { photo_ids: [] },
                                                      { document_ids: [] },
                                                      { impacts_attributes: [:id, :name, :description, :impact_value,
                                                                             :impact_unit, :categoy_id, :is_active, :_destroy] },
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
