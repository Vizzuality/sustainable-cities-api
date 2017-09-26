# frozen_string_literal: true
module V1
  class BlogsController < ApplicationController
    include ErrorSerializer
    include ApiUploads

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Blog'

    before_action :set_blog, only: [:show, :update, :destroy]

    def index
      blogs = BlogsIndex.new(self)
      render json: blogs.blogs, each_serializer: BlogSerializer, include: [:photos],
             links: blogs.links, meta: { total_items: blogs.total_items }
    end

    def show
      render(
        json: @blog,
        serializer: BlogSerializer,
        include: [:photos],
        meta: { updated_at: @blog.updated_at, created_at: @blog.created_at },
      )
    end

    def update
      if @blog.update(blog_params)
        render json: { messages: [{ status: 200, title: "Blog successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@blog.errors, 422), status: 422
      end
    end

    def create
      @blog = Blog.new(blog_params)
      if @blog.save
        render json: { messages: [{ status: 201, title: 'Blog successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@blog.errors, 422), status: 422
      end
    end

    def destroy
      if @blog.destroy
        render json: { messages: [{ status: 200, title: 'Blog successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@blog.errors, 422), status: 422
      end
    end

    private

      def set_blog
        @blog = Blog.find(params[:id])
      end

      def blog_params
        return_params = params.require(:blog).permit(:title, :link, :date, { photos_attributes: [:id, :name, :attachment, :is_active, :_destroy] })

        process_attachments_in(return_params, :photos_attributes)
        process_attachments_in(return_params, :documents_attributes)

        return_params
      end
  end
end
