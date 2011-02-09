#encoding: utf-8
class MessagesController < ApplicationController
  def new   
    @student_to = Student.find(params[:student_id])
  end

  def create    
    @message = Message.new(params[:message])
    puts "-------------------"
    puts "-------------------"
    @message.student_from = @student    
    if @message.save
      respond_to do |format|
        format.html {redirect_back_or_default('/')}
        format.js
      end
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.js {render 'fail_create.js.erb'}
      end  
    end
  end

  def index
    @messages = @student.messages.reverse
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
