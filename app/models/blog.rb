# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string
#  link       :string
#  date       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Blog < ApplicationRecord
  has_many :photos, as: :attacheable, dependent: :destroy
  
  accepts_nested_attributes_for :photos, allow_destroy: true

  scope :filter_by_title_or_link, ->(search_term) { where('blogs.title ilike ? or blogs.link ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?

      blogs = all
      blogs = blogs.filter_by_title_or_link(search_term) if search_term.present?
      blogs
    end
  end
end
