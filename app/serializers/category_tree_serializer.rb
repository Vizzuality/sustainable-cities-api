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
#

class CategoryTreeSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :category_type, :parent_id, :children

  def id
    object.id.to_s
  end

  def parent_id
    object.parent_id.to_s if object.parent_id.present?
  end

  def children
    if !object.is_leaf?
      @children = object.with_children
      @children.map do |child|
        CategoryTreeSerializer.new(child).serializable_hash
      end
    end
  end
end
