# frozen_string_literal: true
class V1::UsersController < ApplicationController
  include ErrorSerializer

  skip_before_action :authenticate

  def index
    render json: User.all, each_serializer: UserSerializer
  end

  def show
    render json: User.find(params[:id]), serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { messages: [{ status: 201, title: 'User successfully created!' }] }, status: 201
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :nickname, :email, :password, :password_confirmation)
    end
end
