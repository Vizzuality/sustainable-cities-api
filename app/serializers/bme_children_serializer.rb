# frozen_string_literal: true

=begin
class BmeChildrenSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :category_type, :parent_id, :bmes, :children

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
        BmeChildrenSerializer.new(child).serializable_hash
      end
    end || []
  end

  def bmes
    @bmes = object.bmes
    @bmes.map do |bme|
      SimpleBmeSerializer.new(bme).serializable_hash
    end
  end
end
=end