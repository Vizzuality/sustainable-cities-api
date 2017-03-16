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
  belongs_to :category, inverse_of: :impacts
  belongs_to :study_case, ->{ where(project_type: 'StudyCase') },
                          class_name: 'Project',
                          foreign_key: 'project_id',
                          inverse_of: :impacts, touch: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  include Activable

  scope :by_name_asc, -> { order('impacts.name ASC') }

  default_scope { by_name_asc }

  class << self
    def fetch_all(options)
      all
    end
  end
end
