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
#  tagline           :string
#  slug              :string
#

class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum project_type: { BusinessModel: 0, StudyCase: 1 }.freeze

  before_save :link_impact_sources
  before_save :unlink_impact_sources

  belongs_to :category, inverse_of: :projects, touch: true, optional: false
  belongs_to :country,  inverse_of: :projects, optional: true, touch: true

  has_many :project_cities
  has_many :cities, through: :project_cities
  #has_one :city, ->() {limit(1)}, class_name: 'ProjectCity'

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

  after_save { cities.find_each(&:touch) }
  after_save { bmes.find_each(&:touch)   }

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

  scope :by_cities,      ( ->(cities)     { where('cities.id': cities)})
  scope :by_solutions,   ( ->(solutions)  { where(category_id: solutions)})

  def city
    cities.first
  end

  def self.fetch_csv(options={})
    projects = Project.includes(:cities, [bmes: :categories])
    projects = projects.by_cities(options[:city_ids].split(',')) if options[:city_ids].present?
    projects = projects.by_solutions(options[:solution_ids].split(',')) if options[:solution_ids].present?
    projects = with_bme_category(options[:bme_ids].split(','), projects) if options[:bme_ids].present?
    projects
  end

  def self.with_bme_category(category_ids, projects)
    category_projects = category_ids.map do |category_id|
      category = Category.find(category_id)

      if category.level == 1
        children = category.children.map { |child| child.children }.flatten
        bmes = children.map { |child| child.bmes }.flatten
        bmes.map { |bme| bme.projects }.flatten.uniq
      elsif category.level == 2
        children = category.children
        bmes = children.map { |child| child.bmes }.flatten
        bmes.map { |bme| bme.projects }.flatten.uniq
      else
        bmes = category.bmes
        bmes.map { |bme| bme.projects }.flatten.uniq
      end
    end.flatten rescue []

    category_projects & projects
  end

  def link_impact_sources
    impacts.each do |impact|
      if impact.external_sources_index.present? && external_sources.present?
        impact.external_sources = impact.external_sources_index.map { |index| external_sources[index] }
      end

      if impact.external_sources_ids.present?
        sources_to_add = external_sources & (ExternalSource.where(id: impact.external_sources_ids) - impact.external_sources) rescue []
        impact.external_sources << sources_to_add
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
      third_level: Category.joins(:bmes).where(bmes: {id: bmes.pluck(:id)}, category_type: "Bme").uniq
    }

    levels[:second_level] = Category.where(id: levels[:third_level].pluck(:parent_id).compact.uniq) rescue []
    levels[:first_level] = Category.where(id: levels[:second_level].pluck(:parent_id).compact.uniq).includes(:children) rescue []

    levels[:first_level].each do |category|
      tree << {
        id: category.id,
        name: category.name,
        slug: category.slug,
        description: category.description,
        label: category.label,
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
        slug: category.slug,
        description: category.description,
        label: category.label,
        children: second_children(category, levels)
      }
    end rescue []
  end

  def second_children(category, levels)
    (category.children.includes(:bmes) & levels[:third_level]).map do |category|
      {
        id: category.id,
        name: category.name,
        slug: category.slug,
        description: category.description,
        label: category.label,
        children: third_children(category, levels)
      }
    end rescue []
  end

  def third_children(category, levels)
    (category.bmes & levels[:fourth_level]).map do |bme|
      {
        id: bme.id,
        name: bme.name,
        slug: bme.slug,
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
