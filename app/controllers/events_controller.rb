class EventsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  before_filter :admin?
  def destroy
    event = Event.find(params[:id])
    day = event.day
    @id = params[:id]
    event.destroy
    if day.events.empty?
      @day_id = day.id
      day.destroy
      week
      respond_to do |format| 
        format.html{redirect_to post} 
        format.js{render 'days/destroy.js.erb'}
      end
    else
      respond_to do |format| 
        format.html{redirect_to post} 
        format.js
      end
    end
  end
end
