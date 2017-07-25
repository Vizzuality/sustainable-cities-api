namespace :update do
  desc 'Updates category levels'
  task category_levels: :environment do
    Category.where(parent_id: nil).each do |category|
      category.update_level
    end
  end
end
