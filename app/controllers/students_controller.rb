class StudentsController < ApplicationController
  skip_before_filter :login_required, :new_message, :info_msg
  


  # render new.rhtml
  def new
    @student = Student.new
  end
  
  def info
    @student_info = Student.find(params[:id])
    @path = params[:path]
    @id = params[:div_id]
  end
  
  def edit    
  end
  
  def change_avatar
    redirect_to "/" if @student.update_attributes(params[:student])
  end
  
  def update
    login = @student.login
    student = Student.authenticate(login, params[:old_password])
    if student
      logout_keeping_session!
      student.update_attributes(params[:student])
      self.current_student = student
      redirect_back_or_default('/')
    else
      render :action => 'edit'
    end
  end
  
 
  def create
    logout_keeping_session!
    @student = Student.create(params[:student])
    success = @student && @student.save
    if success && @student.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_student = @student # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin."
      render :action => 'new'
    end
  end
  
  def show
    @student_show=Student.find_by_id(params[:id])
    @new_msg=@student.messages.collect{|p| p.new}.select{|x| x==true}.size 
  end
  
end
