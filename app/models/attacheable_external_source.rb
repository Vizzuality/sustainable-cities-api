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

  before_destroy :remove_dependent

  def remove_dependent
    if attacheable_type == 'Project'
      impacts_ids = attacheable.impacts.pluck(:id)
      AttacheableExternalSource.where(attacheable: impacts_ids, external_source_id: 325, attacheable_type: 'Impact').each(&:destroy)
    end
  end
end
