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

FactoryGirl.define do
  factory :project do
    name         'A Project'
    project_type 'StudyCase'
    is_active    true
  end

  factory :study_case, class: Project do
    name         'A Study case'
    project_type 'StudyCase'
    is_active    true
  end

  factory :business_model, class: Project do
    name         'A Business model'
    project_type 'BusinessModel'
    is_active    true
  end
end
