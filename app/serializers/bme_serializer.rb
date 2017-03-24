# frozen_string_literal: true
# == Schema Information
#
# Table name: bmes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tmp_bme_id  :integer
#

class BmeSerializer < ActiveModel::Serializer
end
