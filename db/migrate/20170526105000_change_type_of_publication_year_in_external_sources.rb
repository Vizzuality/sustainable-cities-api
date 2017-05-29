class ChangeTypeOfPublicationYearInExternalSources < ActiveRecord::Migration[5.1]
  def change
    add_column :external_sources, :temp_publication_year, :integer

    ExternalSource.all.each do |es|
      es.temp_publication_year = es.publication_year.year if es.publication_year.present?
      es.save!
    end

    remove_column :external_sources, :publication_year
    rename_column :external_sources, :temp_publication_year, :publication_year

  end
end
