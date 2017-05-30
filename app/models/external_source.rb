# frozen_string_literal: true
# == Schema Information
#
# Table name: external_sources
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  web_url          :string
#  source_type      :string
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
  belongs_to :attacheable, polymorphic: true, touch: true

  include Activable
  include Sanitizable

  class << self
    def fetch_all(options)

      # Apply scopes for filtering here
      #search_term = options['search']  if options.present? && options['search'].present?

      # countries = countries.filter_by_name(search_term) if search_term.present?
      all
    end
  end
end
