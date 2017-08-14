# frozen_string_literal: true
module V1
  class CsvsController < ApplicationController
    include ActionController::MimeResponds
    include ErrorSerializer

    PROJECT_COLUMNS = %w(id name situation solution category country city operational_year project_type
                         is_active deactivated_at publish_request published_at is_featured tag_line).freeze
    PROJECT_BME_COLUMNS = %w(project_id project_name bme_name bme_description)
    BME_COLUMNS = %w(id name is_featured category_name category_description)



    skip_before_action :authenticate

    def projects
      @projects = build_projects
      respond_to do |format|
        format.csv  { send_data to_project_csv }
      end
    end

    def bmes
      @bmes = build_bmes
      respond_to do |format|
        format.csv { send_data to_bme_csv}
      end
    end

    private

    def build_projects
      parsed_params = params.permit(:city_ids, :solution_ids, :bme_ids)
      Project.fetch_csv(parsed_params)
    end

    def build_bmes
      parsed_params = params.permit(:city_ids, :solution_ids, :bme_ids)
      Bme.fetch_csv(parsed_params)
    end

    def to_project_csv
      CSV.generate do |csv|
        csv << PROJECT_COLUMNS
        @projects.each do |project|
          csv_line = []
          PROJECT_COLUMNS.each do |attribute|
            value = project.attributes[attribute]
            csv_line << if value.blank?
                          eval("project.#{attribute}.name") rescue ''
                        else
                          value
                        end
          end
          csv << csv_line
        end

        csv << []
        csv << PROJECT_BME_COLUMNS
        @projects.each do |project|
          project.bmes.each do |bme|
            csv << [project.id, project.name, bme.name, bme.description]
          end
        end
      end
    end

    def to_bme_csv
      CSV.generate do |csv|
        csv << BME_COLUMNS
        @bmes.each do |bme|
          csv_line = []
          BME_COLUMNS.each do |attribute|
            value = bme.attributes[attribute]
            csv_line << if value.blank?
                          attribute.include?('name') ? \
                              eval("bme.categories.where(category_type: 'Bme').first.name") \
                              : eval("bme.categories.where(category_type: 'Bme').first.description") rescue ''
                        else
                          value
                        end
          end
          csv << csv_line
        end
      end
    end
  end
end
