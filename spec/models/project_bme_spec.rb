# == Schema Information
#
# Table name: project_bmes
#
#  id         :integer          not null, primary key
#  bme_id     :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectBme, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
