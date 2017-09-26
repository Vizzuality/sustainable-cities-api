# frozen_string_literal: true
module V1
  class EventsController < ApplicationController
    skip_before_action :authenticate, only: [:index, :show]
  end
end
