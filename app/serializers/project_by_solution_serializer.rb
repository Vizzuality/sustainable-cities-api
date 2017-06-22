class ProjectBySolutionSerializer < ActiveModel::Serializer
  attributes :id, :name, :cities, :category

  def cities
  	object.cities.map { |city| { id: city.id, name: city.name } }
  end

  def category
  	{
  		id: object.category.id,
  		name: object.category.name,
  		slug: object.category.slug
  	}	
  end
end
