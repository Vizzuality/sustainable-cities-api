# frozen_string_literal: true
module V1
  class UsersController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'User'

    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = UsersIndex.new(self)
      render json: @users.users, each_serializer: UserSerializer, links: @users.links
    end

    def show
      render json: @user, serializer: UserSerializer, meta: { updated_at: @user.updated_at, created_at: @user.created_at }
    end

    def update
      if @user.update(user_params)
        render json: { messages: [{ status: 200, title: "User successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@user.errors), status: 422
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render json: { messages: [{ status: 201, title: 'User successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@user.errors), status: 422
      end
    end

    def destroy
      if @user.destroy
        render json: { messages: [{ status: 200, title: 'User successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@user.errors), status: 422
      end
    end

    private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        set_user_params = [:name, :email, :country_id, :password, :password_confirmation,
                           :city_id, :nickname, :institution, :position,
                           :twitter_account, :linkedin_account, :image]
        if @current_user.is_active_admin?
          set_user_params << [:role, :is_active]
        end

        params.require(:user).permit(set_user_params)
      end
  end
end
