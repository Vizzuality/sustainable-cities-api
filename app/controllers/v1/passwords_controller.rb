# frozen_string_literal: true
module V1
  class PasswordsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:create, :update_by_token]

  end
end
