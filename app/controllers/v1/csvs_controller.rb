# frozen_string_literal: true
module V1
  class CsvsController < ApplicationController
    include ActionController::MimeResponds
    include ErrorSerializer

    PROJECT_COLUMNS = ['id', 'name', 'situation', 'solution', 'category', 'country', 'operational year', 'project_type', 'published_request',  'is featured']

    skip_before_action :authenticate

    def projects
      @projects = Project.where(projects_params)
      respond_to do |format|
        format.csv  { send_data to_project_csv }
      end
    end

    def bmes

    end

    private

    def projects_params
      params.permit(:city_ids, :solution_id)
    end

    def bme_params
      params.require(:bme).permit(:name, :description, :is_featured, { enabling_ids: [] }, { category_ids: [] },
                                  { external_sources_attributes: [:id, :name, :description, :web_url, :source_type,
                                                                  :author, :publication_year, :institution, :is_active, :_destroy] })
    end

    def to_project_csv
      CSV.generate do |csv|
        csv << PROJECT_COLUMNS
        @projects.each do |project|
          csv << project.attributes.values_at(*PROJECT_COLUMNS)
        end
      end
    end

    def to_bme_csv

    end

  end
end
