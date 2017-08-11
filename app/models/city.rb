# frozen_string_literal: true
# == Schema Information
#
# Table name: cities
#
#  id          :integer          not null, primary key
#  name        :string
#  country_id  :integer
#  iso         :string
#  lat         :decimal(, )
#  lng         :decimal(, )
#  province    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_featured :boolean          default(FALSE)
#

class City < ApplicationRecord
  belongs_to :country, inverse_of: :cities, touch: true

  has_many :users, inverse_of: :city
  has_many :project_cities
  has_many :projects, through: :project_cities
  has_many :photos, as: :attacheable, dependent: :destroy

  accepts_nested_attributes_for :photos, allow_destroy: true

  after_save { projects.find_each(&:touch) }

  validates :name, presence: true

  scope :by_name_asc, -> { order('cities.name ASC') }

  scope :filter_by_name,    ->(search_term) { where('cities.name ilike ?', "%#{search_term}%") }
  scope :filter_by_country, ->(country_id)  { where(country_id: country_id)                    }

  class << self
    def fetch_all(options)
      search_term = options['search']  if options.present? && options['search'].present?
      country_id  = options['country'] if options.present? && options['country'].present?

      cities = includes(:country)
      cities = cities.filter_by_name(search_term)   if search_term.present?
      cities = cities.filter_by_country(country_id) if country_id.present?
      cities
    end
  end

  def bmes_quantity
    city_bmes = Bme.joins(projects: :cities).where("city_id = #{id}")
    categories = Category.includes({ children: [{ children: [:bmes] }] })
                    .where(slug: ["funding-source", "investment-component", "delivery-mechanism", "financial-product"])

    quantity = categories.map do |category|
      children = first_children(category, city_bmes)
      quantity = children.map { |c| c[:quantity] }.reduce(:+)

      {
        id: category.id,
        name: "#{category.name}",
        slug: "#{category.slug}",
        quantity: quantity,
        children: children
      } unless quantity.zero?
    end.compact

    quantity == {} ? [] : quantity
  end

  def first_children(category_level_1, bmes)
    category_level_1.children.map do |category_level_2|
      children = second_children(category_level_2, bmes)
      quantity = children.map { |c| c[:quantity] }.reduce(:+)

      {
        id: category_level_2.id,
        name: "#{category_level_2.name}",
        slug: "#{category_level_2.slug}",
        quantity: quantity,
        children: children
      }
    end
  end

  def second_children(category_level_2, bmes)
    category_level_2.children.map do |category_level_3|
      {
        id: category_level_3.id,
        name: "#{category_level_3.name}",
        slug: "#{category_level_3.slug}",
        quantity: (category_level_3.bmes & bmes).size
      }
    end
  end
end
