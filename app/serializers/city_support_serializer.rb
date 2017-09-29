# frozen_string_literal: true
# == Schema Information
#
# Table name: city_supports
#
#  id           :integer          not null, primary key
#  title        :string
#  description  :text
#  date         :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  image_source :string
#

class CitySupportSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :date, :image_source

  has_many :photos, serializer: PhotoSerializer
end
