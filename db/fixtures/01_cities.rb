if City.count.zero?
  Rake::Task['import_cities_csv:create_cities'].invoke
end
