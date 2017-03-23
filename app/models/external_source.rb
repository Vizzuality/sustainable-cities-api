# frozen_string_literal: true
# == Schema Information
#
# Table name: external_sources
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  web_url          :string
#  source_type      :integer          default(0)
#  author           :string
#  publication_year :datetime
#  institution      :string
#  attacheable_type :string
#  attacheable_id   :integer
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ExternalSource < ApplicationRecord
  belongs_to :attacheable, polymorphic: true

  include Activable
  include Sanitizable
end
