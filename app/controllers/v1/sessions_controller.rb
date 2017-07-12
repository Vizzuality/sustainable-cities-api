# frozen_string_literal: true
module V1
  class SessionsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:create]

  end
end
