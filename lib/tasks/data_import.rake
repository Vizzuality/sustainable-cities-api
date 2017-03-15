require 'csv'

namespace :import_cities_csv do
  desc 'Loads cities data from a csv file'
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

        City.create!(data_cities) if data_row['name'].present?
      end
    end
    puts 'Cities loaded'
  end
end
