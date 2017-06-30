# == Schema Information
#
# Table name: attacheable_external_sources
#
#  id                 :integer          not null, primary key
#  external_source_id :integer
#  attached_id        :integer
#  attached_type      :string
#

class AttacheableExternalSource < ApplicationRecord
  belongs_to :external_source
  belongs_to :attached, polymorphic: true
end
