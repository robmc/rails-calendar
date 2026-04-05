class CalendarController < ApplicationController
  
  before_filter :current_user, :require_user
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, :conditions => {:user_id => current_user.id})
    
    @upcoming_events = current_user.events.where("start_at > ?", Time.now).order("start_at ASC").limit(3)
  end
  
end
