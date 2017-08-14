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
  has_many :categories, through: :bme_categories

  has_many :project_bmes
  has_many :projects, through: :project_bmes

  has_many :business_model_bmes
  has_many :business_models, through: :business_model_bmes

  has_many :attacheable_external_sources, as: :attacheable
  has_many :external_sources, through: :attacheable_external_sources

  after_save { categories.find_each(&:touch) }
  after_save { projects.find_each(&:touch)   }
  after_save { touch_cities                  }

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :projects
  accepts_nested_attributes_for :external_sources, allow_destroy: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  default_scope { where(private: false) }

  scope :by_name_asc, -> { order('bmes.name ASC') }

  scope :by_category, -> {
    where(categories: { category_type: 'Bme' } ) 
  }

  scope :is_private, -> { where(private: true) }

  scope :filter_by_name_or_description, ->(search_term) { where('bmes.name ilike ? or bmes.description ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?
      has_category = options.present? && (options['sort'] == 'category' || options['sort'] == '-category')

      bmes = eager_load([:categories, :enablings])
      bmes = bmes.filter_by_name_or_description(search_term) if search_term.present?
      bmes = bmes.by_category if has_category
      bmes
    end
  end

  def touch_cities
    projects.includes(:cities).map { |project| project.cities }.flatten.uniq.each(&:touch)
  end
end
