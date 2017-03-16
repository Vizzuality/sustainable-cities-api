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

FactoryGirl.define do
  factory :project do
    name 'A Project'
  end

  factory :study_case, class: Project do
    name 'A Study case'
    project_type 'StudyCase'
  end

  factory :business_model, class: Project do
    name 'A Business model'
    project_type 'BusinessModel'
  end
end
