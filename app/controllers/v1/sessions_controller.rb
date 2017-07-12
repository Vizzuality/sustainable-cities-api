# frozen_string_literal: true
module V1
  class SessionsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:create]

    def create
      @user = User.find_by(email: auth_params[:email])

      if !@user || !@user.authenticate(auth_params[:password])
        return render(
          status: 401,
          json: {
            errors: [{ status: '401', title: 'Incorrect email or password' }]
          },
        )
      end

      if auth_params[:current_sign_in_ip].present?
        @user.update(current_sign_in_ip: auth_params[:current_sign_in_ip])
      end

      render(
        status: 200,
        json: JSONAPI::ResourceSerializer
          .new(SessionResource)
          .serialize_to_hash(
            SessionResource.new(
              OpenStruct.new(
                email: auth_params[:email],
                token: Auth.issue({ user: @user.id })
              ),
              current_user,
            )
          )
      )
    end

    private

      def auth_params
        params.require(:data).require(:attributes).permit(:email, :password, :current_sign_in_ip)
      end
  end
end
