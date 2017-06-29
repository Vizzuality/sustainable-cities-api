# frozen_string_literal: true
# == Schema Information
#
# Table name: impacts
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  impact_value :string
#  impact_unit  :string
#  project_id   :integer
#  category_id  :integer
#  is_active    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Impact < ApplicationRecord
  belongs_to :category, inverse_of: :impacts, touch: true
  belongs_to :study_case, ->{ where(project_type: 'StudyCase') },
                              class_name: 'Project',
                              foreign_key: 'project_id',
                              inverse_of: :impacts, touch: true

  has_many :external_sources, as: :attacheable, dependent: :destroy

  accepts_nested_attributes_for :external_sources, allow_destroy: true

  validates :impact_value, presence: true

  include Activable

  scope :by_name_asc, -> { order('impacts.name ASC') }

  scope :filter_by_name_or_description, ->(search_term) { where('impacts.name ilike ? or impacts.description ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?

      impacts = includes(:category, :study_case, :external_sources)
      impacts = impacts.filter_by_name_or_description(search_term) if search_term.present?
      impacts
    end
  end
end
