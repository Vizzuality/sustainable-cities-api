# frozen_string_literal: true
module V1
  class CommentsController < ApplicationController
    include ErrorSerializer

    load_and_authorize_resource class: 'Comment'

    before_action :set_comment, only: [:show, :update, :destroy]

    def index
      @comments = CommentsIndex.new(self)
      render json: @comments.comments, each_serializer: CommentSerializer, links: @comments.links
    end

    def update
      if @comment.update(comment_params)
        render json: { messages: [{ status: 200, title: "Comment successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@comment.errors, 422), status: 422
      end
    end

    def create
      @comment = Comment.build(params[:comment][:commentable_id],
                               params[:comment][:commentable_type],
                               @current_user,
                               params[:comment][:body])
      if @comment.save
        render json: { messages: [{ status: 201, title: 'Comment successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@comment.errors, 422), status: 422
      end
    end

    def destroy
      if @comment.destroy
        render json: { messages: [{ status: 200, title: 'Comment successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@comment.errors, 422), status: 422
      end
    end

    private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:body, :is_active)
      end
  end
end
