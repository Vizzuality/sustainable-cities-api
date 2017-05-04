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
#

class Bme < ApplicationRecord
  has_many :bme_enablings
  has_many :enablings, through: :bme_enablings

  has_many :bme_categories
  has_many :categories, through: :bme_categories

  has_many :project_bmes
  has_many :projects, through: :project_bmes

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :projects

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :by_name_asc, -> { order('bmes.name ASC') }

  scope :filter_by_name_or_description, ->(search_term) { where('bmes.name ilike ? or bmes.description ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?

      bmes = includes(:categories, :enablings)
      bmes = bmes.filter_by_name_or_description(search_term) if search_term.present?
      bmes
    end
  end
end
