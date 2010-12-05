class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def sent
    student_to = Student.find_by_login(params[:message][:student_id])
    @message = Message.new(params[:message])
    @message.student_from = @student
    @message.student = student_to
    student_to.messages << @message
    @student.messages << @message
    if @message.save and @student.save and student_to.save
      flash[:notice] = "Сообщение для #{@student_to.login} отправленно."
      redirect_to(:controller => :messages, :action => :list)
    else
      student_to.messages.pop
      flash[:notice] = 'Сообщение не отправленно'
      render :action => "new"
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
