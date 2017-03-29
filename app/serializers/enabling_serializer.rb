# frozen_string_literal: true
# == Schema Information
#
# Table name: enablings
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  assessment_value :integer          default("Success")
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class EnablingSerializer < ActiveModel::Serializer
end
