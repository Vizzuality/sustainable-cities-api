# frozen_string_literal: true
# == Schema Information
#
# Table name: photos
#
#  id               :integer          not null, primary key
#  name             :string
#  attachment       :string
#  attacheable_type :string
#  attacheable_id   :integer
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :attachment, :is_active

  belongs_to :attacheable
end
