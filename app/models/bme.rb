# frozen_string_literal: true
# == Schema Information
#
# Table name: bmes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tmp_bme_id  :integer
#  is_featured :boolean          default(FALSE)
#  slug        :string
#  private     :boolean          default(FALSE)
#

class Bme < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :bme_enablings
  has_many :enablings, through: :bme_enablings

  has_many :bme_categories
  has_many :categories, ->{ with_private }, through: :bme_categories

  has_many :project_bmes
  has_many :projects, through: :project_bmes

  has_many :business_model_bmes
  has_many :business_models, through: :business_model_bmes

  has_many :attacheable_external_sources, as: :attacheable
  has_many :external_sources, through: :attacheable_external_sources

  has_many :photos, as: :attacheable, dependent: :destroy

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :projects
  accepts_nested_attributes_for :external_sources, allow_destroy: true
  accepts_nested_attributes_for :photos,           allow_destroy: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }, if: '!private'

  validate :has_one_bme_category

  default_scope { where(private: false) }

  scope :with_private, -> { unscope(where: :private) }

  scope :by_name_asc, -> { order('bmes.name ASC') }

  scope :by_category, -> {
    where(categories: { category_type: 'Bme' } )
  }

  scope :is_private, -> { where(private: true) }

  scope :filter_by_name_or_description, ->(search_term) { where('bmes.name ilike ? or bmes.description ilike ?', "%#{search_term}%", "%#{search_term}%") }

  scope :by_cities,      ( ->(cities)     { where('cities.id': cities)})
  scope :by_solutions,   ( ->(solutions)  { where('projects.category_id': solutions)})

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?
      has_category = options.present? && (options['sort'] == 'category' || options['sort'] == '-category')

      bmes = eager_load([:categories, :enablings])
      bmes = bmes.filter_by_name_or_description(search_term) if search_term.present?
      bmes = bmes.by_category if has_category
      bmes
    end

    def fetch_csv(options={})
      bmes = Bme.eager_load([projects: :cities], :categories)
      bmes = bmes.by_cities(options[:city_ids].split(',')) if options[:city_ids].present?
      bmes = bmes.by_solutions(options[:solution_ids].split(',')) if options[:solution_ids].present?
      bmes = first_category_bmes(options[:bme_ids].split(','), bmes) if options[:bme_ids].present?
      bmes
    end

    def first_category_bmes(category_ids, bmes)
      category_ids = Category.where(parent_id: Category.where(parent_id: category_ids)).pluck(:id)
      category_bmes = Bme.joins(:categories).where(categories: {id: category_ids})

      category_bmes & bmes
    end
  end

  def parent_bme_slug
    categories.where(category_type: 'Bme').first.slug rescue nil
  end

  def has_one_bme_category
    error_message = 'must have one and only one of type BME'
    begin
      errors[:categories] << error_message unless categories.to_a.pluck(:category_type).count{|x| x.eql?('Bme')} == 1
    rescue
      errors[:categories] << error_message
    end
  end

end
