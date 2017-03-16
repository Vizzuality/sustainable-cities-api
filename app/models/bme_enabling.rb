# frozen_string_literal: true
# == Schema Information
#
# Table name: bme_enablings
#
#  id          :integer          not null, primary key
#  bme_id      :integer
#  enabling_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BmeEnabling < ApplicationRecord
  belongs_to :bme
  belongs_to :enabling
end
