# frozen_string_literal: true
# == Schema Information
#
# Table name: attacheable_external_sources
#
#  id                 :integer          not null, primary key
#  external_source_id :integer
#  attacheable_id     :integer
#  attacheable_type   :string
#

class AttacheableExternalSource < ApplicationRecord
  belongs_to :external_source
  belongs_to :attacheable, polymorphic: true
end
