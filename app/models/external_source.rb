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
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ExternalSource < ApplicationRecord
  has_many :attacheable_external_sources
  has_many :impacts,  through: :attacheable_external_sources, source: :attacheable, source_type: "Impact"
  has_many :projects, through: :attacheable_external_sources, source: :attacheable, source_type: "Project"
  has_many :bmes,     through: :attacheable_external_sources, source: :attacheable, source_type: "Bme"

  after_save { impacts.find_each(&:touch)  }
  after_save { projects.find_each(&:touch) }
  after_save { bmes.find_each(&:touch)     }

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
