class CitySupportCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :city_supports
end
