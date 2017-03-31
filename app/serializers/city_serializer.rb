# frozen_string_literal: true
# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  iso        :string
#  lat        :decimal(, )
#  lng        :decimal(, )
#  province   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :iso, :lat, :lng, :province

  belongs_to :country, serializer: CountrySerializer
end
