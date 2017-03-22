require 'csv'

namespace :import_cities_csv do
  desc 'Loads Cities data from a csv file'
  task create_cities: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'cities.csv'))
    puts '* Loading Cities... *'
    City.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        country_name = data_row['iso3'] if data_row['iso3'].present?
        country      = Country.find_by(iso: country_name) if country_name.present?

        data_cities = {}
        data_cities[:name]       = data_row['name']
        data_cities[:lat]        = data_row['lat']
        data_cities[:lng]        = data_row['lng']
        data_cities[:province]   = data_row['province']
        data_cities[:country_id] = country.id if country.present?
        data_cities[:iso]        = data_row['iso3']

        City.create!(data_cities) if data_row['name'].present?
      end
    end
    puts 'Cities loaded'
  end
end

namespace :import_bmes_csv do
  desc "Loads BME's data from a csv file"
  task create_bmes: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'bmes.csv'))
    puts "* Loading BME's... *"
    Bme.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        categories = []

        category_bme_1 = data_row['category_bme_1']
        if category_bme_1.present?
          category_1 = Category.where(name: category_bme_1, category_type: 'Bme').first_or_create
          categories << category_1
        end

        category_bme_2 = data_row['category_bme_2']
        if category_bme_2.present?
          category_2 = Category.where(name: category_bme_2, category_type: 'Bme', parent_id: category_1).first_or_create
          categories << category_2
        end

        category_bme_3 = data_row['category_bme_3']
        if category_bme_3.present?
          categories << Category.where(name: category_bme_3, category_type: 'Bme', parent_id: category_2).first_or_create
        end

        category_timing_1 = data_row['category_timing_1']
        if category_timing_1.present?
          timings = category_timing_1.split('||')
          timings.each do |timing|
            categories << Category.where(name: timing, category_type: 'Timing').first_or_create
          end
        end

        data_bmes = {}
        data_bmes[:name]        = data_row['name']
        data_bmes[:description] = data_row['description']
        data_bmes[:tmp_bme_id]  = data_row['tmp_bme_id'].to_i

        bme = Bme.where(data_bmes).first_or_create
        bme.update!(categories: categories) if categories.present?
      end
    end
    puts "BME's loaded"
  end
end

namespace :import_enablings_csv do
  desc "Loads Enablings data from a csv file"
  task create_enablings: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'enablings.csv'))
    puts "* Loading Enablings... *"
    Enabling.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        data_enablings = {}
        data_enablings[:name]             = data_row['name']
        data_enablings[:assessment_value] = data_row['assessment_value'].to_i

        bme_ids = Bme.where(tmp_bme_id: data_row['tmp_bme_id']).pluck(:id)

        enabling = Enabling.where(data_enablings).first_or_create
        enabling.update!(bme_ids: bme_ids) if [data_row['tmp_bme_id']].present? && bme_ids.present?
      end
    end
    puts "Enablings loaded"
  end
end

namespace :import_enabling_categories_csv do
  desc "Loads Enabling categories data from a csv file"
  task create_enabling_categories: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'enabling_categories.csv'))
    puts "* Loading Enabling categories... *"
    Enabling.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        categories = []

        category_0 = data_row['category_0']
        if category_0.present?
          category_0 = Category.where(name: category_0, category_type: 'Enabling').first_or_create
          categories << category_0
        end

        category_1 = data_row['category_1']
        if category_1.present?
          category_1 = Category.where(name: category_1, category_type: 'Enabling', parent_id: category_0).first_or_create
          categories << category_1
        end

        category_2 = data_row['category_2']
        if category_2.present?
          category_2 = Category.where(name: category_2, category_type: 'Enabling', parent_id: category_1).first_or_create
          categories << category_2
        end

        category_3 = data_row['category_3']
        if category_3.present?
          category_3 = Category.where(name: category_3, category_type: 'Enabling', parent_id: category_2).first_or_create
          categories << category_3
        end

        category = category_3 || category_2 || category_1 || category_0

        enabling = Enabling.where(name: data_row['name']).first_or_create
        enabling.update!(category_id: category.id) if category.present?
      end
    end
    puts "Enabling categories loaded"
  end
end

namespace :import_study_cases_csv do
  desc "Loads Study cases data from a csv file"
  task create_study_cases: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'study_cases.csv'))
    puts "* Loading Study cases... *"
    Project.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        categories = []

        category_1 = data_row['category_1']
        if category_1.present?
          category_1 = Category.where(name: category_1, category_type: 'Solution').first_or_create
          categories << category_1
        end

        category_2 = data_row['category_2']
        if category_2.present?
          category_2 = Category.where(name: category_2, category_type: 'Solution', parent_id: category_1).first_or_create
          categories << category_2
        end

        category_3 = data_row['category_3']
        if category_3.present?
          category_3 = Category.where(name: category_3, category_type: 'Solution', parent_id: category_2).first_or_create
          categories << category_3
        end

        category    = category_3 || category_2 || category_1
        category_id = category.id if category.present?

        assign_country_id = if country = Country.find_by(iso: data_row['iso'])
                              country.id
                            else
                              nil
                            end

        assign_city_id = City.where(name: data_row['city'], iso: data_row['iso']).first_or_create.id

        data_study_cases = {}
        data_study_cases[:name]              = data_row['name']
        data_study_cases[:tmp_study_case_id] = data_row['tmp_study_case_id'].to_i
        data_study_cases[:situation]         = data_row['situation']
        data_study_cases[:solution]          = data_row['solution']
        data_study_cases[:operational_year]  = '01/01/' << data_row['operational_year'] if data_row['operational_year'].present?
        data_study_cases[:project_type]      = 'StudyCase'

        project = Project.where(data_study_cases).first_or_create
        project.update!(category_id: category_id, country_id: assign_country_id, city_id: assign_city_id, published_at: DateTime.now, is_active: true)
      end
    end
    puts "Study cases loaded"
  end
end

namespace :import_study_cases_bmes_csv do
  desc "Loads Study cases bmes data from a csv file"
  task create_study_cases_bmes: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'study_cases_bmes.csv'))
    puts "* Loading Study cases bmes... *"
    Project.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        assign_bme     = Bme.where(name: data_row['bme_name']).first_or_create
        assign_project = Project.find_by(tmp_study_case_id: data_row['tmp_study_case_id'].to_i)

        data_study_cases_bmes = {}
        data_study_cases_bmes[:bme]     = assign_bme
        data_study_cases_bmes[:project] = assign_project

        project_bme = ProjectBme.where(data_study_cases_bmes).first_or_create
        project_bme.update!(description: data_row['description'])
      end
    end
    puts "Study cases bmes loaded"
  end
end

namespace :import_external_sources_csv do
  desc 'Loads Sources data from a csv file'
  task create_external_sources: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'sources.csv'))
    puts '* Loading Sources... *'
    ExternalSource.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        data_external_sources = {}
        data_external_sources[:source_type]      = data_row['source_type']
        data_external_sources[:author]           = data_row['author']
        data_external_sources[:publication_year] = '01/01/' << data_row['publication_year'] if data_row['publication_year'].present?
        data_external_sources[:name]             = data_row['name']
        data_external_sources[:institution]      = data_row['institution']

        source = ExternalSource.where(data_external_sources).first_or_create
        source.update!(web_url: data_row['web_url'], is_active: true)
      end
    end
    puts 'Sources loaded'
  end
end

namespace :import_study_cases_sources_csv do
  desc "Loads Study cases sources data from a csv file"
  task create_study_cases_sources: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'study_cases_sources.csv'))
    puts "* Loading Study cases sources... *"
    Project.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        assign_source = ExternalSource.where(name: data_row['source_name']).first_or_create if data_row['source_name'].present?
        assign_source.update!(is_active: true)                                              if assign_source.present?

        project = Project.find_by(name: data_row['study_case_name'])
        project.update!(external_sources: [assign_source]) if project.present? && assign_source.present?
      end
    end
    puts "Study cases sources loaded"
  end
end

namespace :import_impacts_csv do
  desc "Loads Impacts data from a csv file"
  task create_impacts: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'impacts.csv'))
    puts "* Loading Impacts... *"
    Impact.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        categories = []

        category_1 = data_row['category_1']
        if category_1.present?
          category_1 = Category.where(name: category_1, category_type: 'Impact').first_or_create
          categories << category_1
        end

        category_2 = data_row['category_2']
        if category_2.present?
          category_2 = Category.where(name: category_2, category_type: 'Impact', parent_id: category_1).first_or_create
          categories << category_2
        end

        category    = category_2 || category_1
        category_id = category.id if category.present?

        data_impacts = {}
        data_impacts[:name]         = data_row['name']
        data_impacts[:impact_unit]  = data_row['impact_unit']
        data_impacts[:impact_value] = data_row['impact_value']

        assign_source = ExternalSource.where(name: data_row['source_name']).first_or_create if data_row['source_name'].present?
        assign_source.update!(is_active: true)                                              if assign_source.present?
        assign_project = Project.find_by(name: data_row['study_case_name'])                 if data_row['study_case_name'].present?

        impact = Impact.where(data_impacts).first_or_create
        impact.update!(category_id: category_id, is_active: true)
        impact.update!(external_sources: [assign_source]) if assign_source.present?
        impact.update!(study_case: assign_project)        if assign_project.present?
      end
    end
    puts "Impacts loaded"
  end
end
