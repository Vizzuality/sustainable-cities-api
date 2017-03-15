# == Schema Information
#
# Table name: project_cities
#
#  id         :integer          not null, primary key
#  city_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectCity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
