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

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :situation, :solution, :category_id, :country_id,
             :operational_year, :project_type, :is_active, :is_featured,
             :deactivated_at, :publish_request, :published_at

  belongs_to :country,  serializer: CountrySerializer
  belongs_to :category, serializer: CategorySerializer

  #  has_many :bmes,             serializer: BmeSerializer
  has_many :project_bmes,             serializer: ProjectBmeSerializer

  has_many :impacts,          serializer: ImpactSerializer
  has_many :cities,           serializer: CitySerializer
  has_many :users,            serializer: UserSerializer
  has_many :photos,           serializer: PhotoSerializer
  has_many :documents,        serializer: DocumentSerializer
  has_many :external_sources, serializer: ExternalSourceSerializer
  has_many :comments,         serializer: CommentSerializer
end
