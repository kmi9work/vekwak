class MessagesController < ApplicationController
  def new
    @message = Message.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  def sent
    student_to = Student.find_by_login(params[:message][:student_id])
    @message = Message.new(params[:message])
    @message.student_from = @student
    @message.student = student_to
    student_to.messages << @message
    @student.messages << @message
    respond_to do |format|
      if @message.save and @student.save and student_to.save
        flash[:notice] = "Сообщение для #{@student_to.login} отправленно."
        format.html { redirect_to(:controller => :messages, :action => :list) }        
      else
        student_to.messages.pop
        flash[:notice] = 'Сообщение не отправленно'
        format.html { render :action => "new" }
      end
    end
  end

  def index
    @messages = @student.messages
    respond_to do |format|
      format.html # list.html.erb      
    end
  end

  def show
    @message = Message.find_by_id(params[:message_id])
    @message.new = 0
    @message.save
  end

end
