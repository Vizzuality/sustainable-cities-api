# == Schema Information
#
# Table name: city_support_categories
#
#  id         :integer          not null, primary key
#  title      :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CitySupportCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :city_supports
end
