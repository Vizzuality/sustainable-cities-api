# frozen_string_literal: true
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

class ExternalSourceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :web_url, :source_type, :author, :publication_year, :institution, :is_active

  has_many :projects, serializer: ProjectSerializer
  has_many :impacts, serializer: ImpactSerializer
  has_many :bmes, serializer: BmeSerializer
end
