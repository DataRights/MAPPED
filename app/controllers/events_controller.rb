class EventsController < ApplicationController
  def find
    render json: Event.find(params[:id])&.to_json, :status => :ok
  end
end
