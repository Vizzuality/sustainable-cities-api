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
end
