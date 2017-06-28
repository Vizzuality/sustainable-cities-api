# frozen_string_literal: true
# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  parent_id     :integer
#  category_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  label         :string
#

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :category_type, :label

  belongs_to :parent,   serializer: CategorySerializer
  has_many   :children, serializer: CategorySerializer
end
