# frozen_string_literal: true

class BmeCategorySerializer < ActiveModel::Serializer
  attributes :children, :bmes

  def children
    children = if !object.is_leaf?
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
