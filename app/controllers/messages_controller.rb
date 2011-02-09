#encoding: utf-8
class MessagesController < ApplicationController
  def new   
    @student_to = Student.find(params[:student_id])
  end

  def create
    student_to = Student.find_by_id(params[:message][:student_id])
    @message = Message.new(params[:message])
    @message.student_from = @student
    @message.student = student_to
    student_to.messages << @message
    @student.messages << @message
    if @message.save and @student.save and student_to.save
      respond_to do |format|
        format.html {redirect_back_or_default('/')}
        format.js
      end
    else
      student_to.messages.pop
      respond_to do |format|
        format.html {render :action => 'new'}
        format.js {render 'fail_create.js.erb'}
      end  
    end
  end

  def index
    @messages = @student.messages
  end

  def show
    @message = Message.find_by_id(params[:message_id])
    @message.new = 0
    @message.save
  end

end
