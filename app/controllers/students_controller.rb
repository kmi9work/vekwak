class StudentsController < ApplicationController
  skip_before_filter :login_required, :new_message
  

  # render new.rhtml
  def new
    @student = Student.new
  end
 
  def create
    logout_keeping_session!
    @student = Student.create(params[:student])
    if params[:student][:headman]
      @student[:headman] = true
    end
    if params[:student][:admin]
      @student[:admin] = true
    end
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
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def show
    @student_show=Student.find_by_id(params[:id])
    @new_msg=@student.messages.collect{|p| p.new}.select{|x| x==true}.size 
  end
  
end
