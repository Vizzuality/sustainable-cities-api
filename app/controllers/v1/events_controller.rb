# frozen_string_literal: true
module V1
  class EventsController < ApplicationController
    include ErrorSerializer
    include ApiUploads

    skip_before_action :authenticate, only: [:index, :show]
    load_and_authorize_resource class: 'Event'

    before_action :set_event, only: [:show, :update, :destroy]

    def index
      events = EventsIndex.new(self)
      render json: events.events, each_serializer: EventSerializer, include: [:photos],
             links: events.links, meta: { total_items: events.total_items }
    end

    def show
      render(
        json: @event,
        serializer: EventSerializer,
        include: [:photos],
        meta: { updated_at: @event.updated_at, created_at: @event.created_at },
      )
    end

    def update
      if @event.update(event_params)
        render json: { messages: [{ status: 200, title: "Event successfully updated!" }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@event.errors, 422), status: 422
      end
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        render json: { messages: [{ status: 201, title: 'Event successfully created!' }] }, status: 201
      else
        render json: ErrorSerializer.serialize(@event.errors, 422), status: 422
      end
    end

    def destroy
      if @event.destroy
        render json: { messages: [{ status: 200, title: 'Event successfully deleted!' }] }, status: 200
      else
        render json: ErrorSerializer.serialize(@event.errors, 422), status: 422
      end
    end

    private

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        return_params = params.require(:event).permit(:title, :link, :date, { photos_attributes: [:id, :name, :attachment, :is_active, :_destroy] })

        process_attachments_in(return_params, :photos_attributes)
        process_attachments_in(return_params, :documents_attributes)

        return_params
      end
  end
end
