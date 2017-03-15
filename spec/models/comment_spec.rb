# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_type :string
#  commentable_id   :integer
#  body             :text
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  # before :each do
  #   @user = create(:user)
  #   @body = 'Lorem ipsum dolor..'
  # end

  # it 'Comment on projects' do
  #   @comment = Comment.build(@project, @user, @body)
  #   @comment.save!
  #   expect(@comment.valid?).to           eq(true)
  #   expect(@comment.commentable_type).to eq('Project')
  #   expect(@project.comments.size).to    eq(1)
  #   expect(@user.comments.size).to       eq(1)
  # end
end
