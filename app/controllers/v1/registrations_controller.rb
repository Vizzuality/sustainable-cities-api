# frozen_string_literal: true
module V1
  class RegistrationsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate

  end
end
