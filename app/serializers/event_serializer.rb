# frozen_string_literal: true
# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string
#  link       :string
#  date       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :date

  has_many :photos, serializer: PhotoSerializer
end
