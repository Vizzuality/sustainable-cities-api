# frozen_string_literal: true
# == Schema Information
#
# Table name: documents
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

class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :name, :attachment, :is_active

  belongs_to :attacheable
end
