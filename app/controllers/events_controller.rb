class EventsController < ApplicationController
  def destroy
    event = Event.find(params[:id])
    day = event.day
    if @student.admin
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
    else
      respond_to do |format| 
        format.html{render :nothing, :status => 403} 
        format.js{render 'fail.js.erb', :locals => {:msg => "U r not admin!"}}
      end
    end
  end
end
