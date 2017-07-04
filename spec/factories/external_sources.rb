# == Schema Information
#
# Table name: external_sources
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  web_url          :string
#  source_type      :string
#  author           :string
#  publication_year :datetime
#  institution      :string
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :external_source do
    name 'External source'
    web_url 'test-web.org'
    is_active true
    association :projects, factory: :study_case
  end

  factory :external_source_with_projects, parent: :external_source do
    projects { [FactoryGirl.create(:study_case)] }
  end
end
