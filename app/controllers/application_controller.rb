# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required, :stud, :new_message, :headman_msg, :stud_online, :week
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password  
  def stud
    @student = current_student
    @students= Student.all
  end

  def stud_online
    @students_online=Student.find(:all, :conditions => ["last_visit >=?", 5.minutes.ago])
  end
  
  def new_message
    #@msg_count=Message.find_all_by_student_to(@student.login, :conditions => "new=1").size    
    @new_msg=@student.messages.collect{|p| p.new}.select{|x| x==true}.size    
  end
  def headman_msg
    @headman_msg = HeadmanAul.order('created_at asc').last
  end
  def week
    t = Time.now - 1.day
    @wdays = []
    7.times do
      if a = Day.where(["day = ? and month = ? and year = ?", t.day, t.month, t.year]).last
        @wdays << a
      else
        @wdays << Day.new(:day => t.day, :month => t.month, :year => t.year)
      end
      t += 1.day
    end
  end
  
end
