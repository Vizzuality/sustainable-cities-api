# frozen_string_literal: true
# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  name             :string
#  region_name      :string
#  iso              :string
#  region_iso       :string
#  country_centroid :jsonb
#  region_centroid  :jsonb
#  is_active        :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :region_name, :iso, :region_iso, :country_centroid, :region_centroid, :is_active
end
