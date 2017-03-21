# frozen_string_literal: true
class V1::CurrentUserController < ApplicationController
  def show
    render json: current_user, serializer: UserSerializer
  end
end
