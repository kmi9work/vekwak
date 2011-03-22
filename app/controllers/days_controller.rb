class DaysController < ApplicationController
  before_filter :login_required, :only => [:create, :new, :add]
  def index
    @days = Day.order("created_at desc").all
  end
  def show
    day = Day.find(params[:id])
    @events = day.events
    @day_day = day.day
    respond_to do |format|
      format.html
      format.js
    end
  end
  def new
  end
  def add
  end
  def create
    if params[:id]
      @day = Day.find(params[:id])
      day_success = true
    else
      t = Time.parse(params[:date].gsub("_", "."))
      @day = Day.new(:day => t.day, :month => t.month, :year => t.year, :student_id => @student.id)
      day_success = @day && @day.save
      day_success = day_success and @day.errors.empty?
    end
    @event = Event.create(params[:event])
    @event.day_id = @day.id
    event_success = @event && @event.save
    if day_success and event_success and @event.errors.empty?
      week
      respond_to do |format|
        format.html {redirect_back_or_default('/')}
        format.js
      end
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.js {render 'fail.js.erb', :locals => {:msg => "Error when creating."}}
      end
    end
  end
  
  def next_week
    week(params[:fday].to_i)
    respond_to do |format|
      format.html {render :refresh}
      format.js
    end
  end
  
  def prev_week
    week(params[:fday].to_i)
    respond_to do |format|
      format.html {render :refresh}
      format.js
    end
  end
  
end
