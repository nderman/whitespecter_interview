# frozen_string_literal: true
class GroupEventsController < ApplicationController
  before_action :set_group_event, only: [:show, :update, :destroy]
  def index
    @group_events = GroupEvent.all
    render(json: @group_events, status: :ok)
  end

  def show
    render(json: @group_event, status: :ok)
  end

  def create
    @group_event = GroupEvent.create!(event_params)
    render(json: @group_event, status: :created)
  end

  def update
    @group_event.update(event_params)
    head(:no_content)
  end

  def destroy
    @group_event.update_attribute(:deleted, true)
    head(:no_content)
  end

  private

  def event_params
    params.permit(:start_date, :end_date, :duration, :name, :description, :deleted, :location, :published)
  end

  def set_group_event
    @group_event = GroupEvent.find(params[:id])
  end
end
