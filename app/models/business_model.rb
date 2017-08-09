# == Schema Information
#
# Table name: business_models
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  solution_id :integer
#  link_share  :string
#  link_edit   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :integer
#

class BusinessModel < ApplicationRecord
  belongs_to :solution, :class_name => "Category"
  belongs_to :owner, :class_name => "User"

  has_many :business_model_bmes
  has_many :bmes, through: :business_model_bmes

  has_many :business_model_enablings
  has_many :enablings, through: :business_model_enablings

  has_many :business_model_users
  has_many :users, through: :business_model_users

  after_save :set_links
  # after_update :add_user

  def set_links
    update_column(:link_share, link_hash("share", id))
    update_column(:link_edit, link_hash("edit", id))
  end

  def link_hash(type, id)
    values_string = ENV['BASE_HASH'] + id.to_s + type
    Digest::SHA1.hexdigest(values_string)
  end
end
