# frozen_string_literal: true
# == Schema Information
#
# Table name: bme_categories
#
#  id          :integer          not null, primary key
#  bme_id      :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BmeCategory < ApplicationRecord
  belongs_to :bme
  belongs_to :category
end
