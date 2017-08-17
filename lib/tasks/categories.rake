namespace :categories do
  desc 'Creates custom elements category for every bme category of level 2'
  task custom_elements: :environment do
    categories = Category.where(category_type: 'Bme', level: 2)

    categories.each do |category|
      Category.create(level: 3,
                      name: "#{category.name} custom elements",
                      parent_id: category.id,
                      category_type: 'Bme',
                      private: true)
    end
  end
end
