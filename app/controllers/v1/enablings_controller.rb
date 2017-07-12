# frozen_string_literal: true
module V1
  class EnablingsController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Enabling'

  end
end
