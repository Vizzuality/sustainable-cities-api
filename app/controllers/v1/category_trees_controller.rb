module V1
  class CategoryTreesController < ApplicationController
    include ErrorSerializer

    skip_before_action :authenticate, only: [:index]
    load_and_authorize_resource class: 'Category'


  end
end
