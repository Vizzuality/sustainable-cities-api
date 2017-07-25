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

  has_many :attacheable_external_sources, as: :attacheable
  has_many :external_sources, through: :attacheable_external_sources

  has_many :photos, as: :attacheable, dependent: :destroy
  has_many :documents, as: :attacheable, dependent: :destroy

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :projects
  accepts_nested_attributes_for :external_sources, allow_destroy: true
  accepts_nested_attributes_for :photos,           allow_destroy: true
  accepts_nested_attributes_for :documents,        allow_destroy: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  validate :has_one_bme_category

  scope :by_name_asc, -> { order('bmes.name ASC') }

  scope :by_category, -> {
    where(categories: { category_type: 'Bme' } )
  }

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


  def has_one_bme_category
    error_message = 'must have one and only one of type BME'
    begin
      errors[:categories] << error_message unless categories.to_a.pluck(:category_type).count{|x| x.eql?('Bme')} == 1
    rescue
      errors[:categories] << error_message
    end
  end

end
