# frozen_string_literal: true
module V1
  class CitySupportsController < ApplicationController
    skip_before_action :authenticate, only: [:index, :show]
  end
end
