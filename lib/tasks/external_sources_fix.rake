desc 'Fixes bug in external sources for impacts'
task fix_external_sources: :environment do
  AttacheableExternalSource.where(attacheable_type: 'Impact').find_each do |att|
    begin
      AttacheableExternalSource.where(external_source_id: att.external_source_id,
                                      attacheable_type: 'Project',
                                      attacheable_id: Impact.find(att.attacheable_id).project_id).first_or_create
    rescue ActiveRecord::RecordNotFound => e
      puts e
    end

  end
end