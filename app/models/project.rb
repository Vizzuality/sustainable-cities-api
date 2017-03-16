# frozen_string_literal: true
# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  name             :string
#  situation        :text
#  solution         :text
#  category_id      :integer
#  country_id       :integer
#  operational_year :datetime
#  project_type     :integer
#  is_active        :boolean          default(FALSE)
#  deactivated_at   :datetime
#  publish_request  :boolean          default(FALSE)
#  published_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Project < ApplicationRecord
  enum project_type: { BusinessModel: 0, StudyCase: 1 }

  belongs_to :category, inverse_of: :projects

  has_many :project_cities
  has_many :cities, through: :project_cities

  has_many :project_users
  has_many :users, through: :project_users

  has_many :project_bmes
  has_many :bmes, through: :project_bmes

  has_many :photos,           as: :attacheable, dependent: :destroy
  has_many :documents,        as: :attacheable, dependent: :destroy
  has_many :external_sources, as: :attacheable, dependent: :destroy
  has_many :comments,         as: :commentable, dependent: :destroy
  has_many :impacts,          dependent: :destroy, inverse_of: :study_case

  validates :name, presence: true

  scope :by_name_asc,       -> { order('projects.name ASC')           }
  scope :by_study_case,     -> { where(project_type: 'StudyCase')     }
  scope :by_business_model, -> { where(project_type: 'BusinessModel') }

  default_scope { by_name_asc }

  class << self
    def fetch_all(options)
      all
    end
  end
end
