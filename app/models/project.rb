# frozen_string_literal: true
# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  name              :string
#  situation         :text
#  solution          :text
#  category_id       :integer
#  country_id        :integer
#  operational_year  :datetime
#  project_type      :integer
#  is_active         :boolean          default(FALSE)
#  deactivated_at    :datetime
#  publish_request   :boolean          default(FALSE)
#  published_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  tmp_study_case_id :integer
#  is_featured       :boolean          default(FALSE)
#

class Project < ApplicationRecord
  enum project_type: { BusinessModel: 0, StudyCase: 1 }.freeze

  before_save :link_impact_sources
  before_save :unlink_impact_sources

  belongs_to :category, inverse_of: :projects, touch: true
  belongs_to :country,  inverse_of: :projects, optional: true, touch: true

  has_many :project_cities
  has_many :cities, through: :project_cities

  has_many :project_users
  has_many :users, through: :project_users

  has_many :project_bmes
  has_many :bmes, through: :project_bmes

  has_many :photos,           as: :attacheable,        dependent: :destroy
  has_many :documents,        as: :attacheable,        dependent: :destroy
  has_many :comments,         as: :commentable,        dependent: :destroy
  has_many :impacts,          inverse_of: :study_case, dependent: :destroy

  has_many :attacheable_external_sources, as: :attacheable
  has_many :external_sources, through: :attacheable_external_sources

  accepts_nested_attributes_for :bmes
  accepts_nested_attributes_for :external_sources, allow_destroy: true
  accepts_nested_attributes_for :documents,        allow_destroy: true
  accepts_nested_attributes_for :photos,           allow_destroy: true
  accepts_nested_attributes_for :impacts,          allow_destroy: true
  accepts_nested_attributes_for :comments,         allow_destroy: true
  accepts_nested_attributes_for :project_bmes,     allow_destroy: true

  validates :name, presence: true
  validates :project_type, presence: true, inclusion: { in: %w(BusinessModel StudyCase) }, on: :create
  validates_length_of :tagline, maximum: 165

  include Activable

  scope :by_name_asc,            ->     { order('projects.name ASC')                                                                          }
  scope :by_study_case,          ->     { where(project_type: 'StudyCase')                                                                    }
  scope :by_business_model,      ->     { where(project_type: 'BusinessModel')                                                                }
  scope :by_user_business_model, ->user { joins(:project_users).where('project_users.user_id = ?', user).where(project_type: 'BusinessModel') }
  scope :available,              ->     { where(is_active: true)                                                                              }

  scope :include_relations, -> {
    includes(:category, { category: [:parent, :children] }, :country,
             :bmes, { bmes: [:categories, :enablings] }, :impacts,
             :cities, { cities: :country }, :users, :photos, :documents,
             :external_sources, :comments)
  }

  scope :filter_by_name_or_solution, ->(search_term) { where('projects.name ilike ? or projects.solution ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options=nil)
      study_cases     = options['study_cases']     if options.present? && options['study_cases'].present?
      business_models = options['business_models'] if options.present? && options['business_models'].present?
      user            = options['current_user']    if options.present? && options['current_user'].present?
      search_term     = options['search']          if options.present? && options['search'].present?

      projects = available.includes(:country, :category, :bmes,
                                    :impacts, :cities, { cities: :country },
                                    :users, :photos, :documents, :external_sources, :comments)
      if study_cases.present?
        projects = projects.by_study_case
      end

      if business_models.present? && user.present?
        if user.is_active_user? || user.is_active_editor?
          projects = projects.by_user_business_model(user.id)
        elsif user.is_active_admin? || user.is_active_publisher?
          projects = projects.by_business_model
        end
      end

      projects = projects.filter_by_name_or_solution(search_term) if search_term.present?

      projects
    end
  end

  def link_impact_sources
    impacts.each do |impact|
      if impact.external_sources_index.present? && external_sources.present?
        impact.external_sources = impact.external_sources_index.map { |index| external_sources[index] }
      end
    end
  end

  def unlink_impact_sources
    impacts.each do |impact|
      if impact.remove_external_sources.present? && impact.external_sources.present?
        impact.remove_external_sources.each do |id|
          impact.external_sources.delete(id)
        end
      end
    end
  end

  def bme_tree
    tree = []
    levels = {
      fourth_level: bmes,
      third_level: bmes.map(&:categories).flatten.uniq.compact
    }

    levels[:second_level] = levels[:third_level].map(&:parent).uniq.compact rescue []
    levels[:first_level] = levels[:second_level].map(&:parent).uniq.compact rescue []

    levels[:first_level].each do |category|
      tree << {
        id: category.id,
        name: category.name,
        children: first_children(category, levels)
      }
    end rescue []

    tree
  end

  def first_children(category, levels)
    (category.children & levels[:second_level]).map do |category|
      {
        id: category.id,
        name: category.name,
        children: second_children(category, levels)
      }
    end rescue []
  end

  def second_children(category, levels)
    (category.children & levels[:third_level]).map do |category|
      {
        id: category.id,
        name: category.name,
        children: third_children(category, levels)
      }
    end rescue []
  end

  def third_children(category, levels)
    (category.bmes & levels[:fourth_level]).map do |bme|
      {
        id: bme.id,
        name: bme.name,
        description: bme.description
      }
    end rescue []
  end

  def attributes
    super.merge(
      {
         'cities' => {}
       }
    )
  end

end
