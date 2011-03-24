#encoding: utf-8
class MessagesController < ApplicationController
  before_filter :login_required
  def new   
    @student_to = Student.find(params[:student_id])
  end

  def create    
    @message = Message.new(params[:message])    
    @message.student_from = @student    
    if @message.student_from == @message.student
      @message.content = "Я никогда больше не буду писать сам себе! Я никогда больше не буду писать сам себе! Я никогда больше не буду писать сам себе!"
    end
    if @message.save
      respond_to do |format|
        format.html {redirect_back_or_default('/')}
        format.js
      end
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.js {render 'layouts/fail.js.erb', :locals => {:msg => "Can't create."}}
      end  
    end
  end

  def index
    @messages = @student.messages.reverse    
    @messages = @messages.paginate :page => params[:page], :per_page => 20  
  end

  def show
    @message = Message.find_by_id(params[:id])
    @message.new = 0
    @message.save
    respond_to do |format|
      format.html
      format.js
    end  
  end
end
