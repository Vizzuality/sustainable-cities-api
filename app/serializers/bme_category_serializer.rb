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

=begin
class BmeCategorySerializer < ActiveModel::Serializer
  attributes :children, :bmes

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
