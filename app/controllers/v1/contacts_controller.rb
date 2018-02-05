# frozen_string_literal: true
module V1
  class ContactsController < ApplicationController

    load_and_authorize_resource class: 'Contact'
    skip_before_action :authenticate, only: :create

  end
end
