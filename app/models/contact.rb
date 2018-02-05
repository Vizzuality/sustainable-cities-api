# == Schema Information
#
# Table name: contacts
#
#  id    :integer          not null, primary key
#  name  :string
#  email :string           not null
#

class Contact < ApplicationRecord
  validates_presence_of :email
  validates_uniqueness_of :email
end
