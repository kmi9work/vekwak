# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required, :stud, :new_message, :stud_online, :week, :info_msg
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password  
  

  def stud
    @student = current_student
    @students = Student.all
    @sections = Section.all
  end

  def stud_online
    @students_online=Student.find(:all, :conditions => ["last_visit >=?", 5.minutes.ago])
  end
  
  def new_message
    #@msg_count=Message.find_all_by_student_to(@student.login, :conditions => "new=1").size    
    @new_message=@student.messages.collect{|p| p.new}.select{|x| x==true}.size    
  end
  def info_msg
    @headman_msg = HeadmanAul.order('created_at desc').first(5)
    @last_comments = Comment.order('created_at desc').first(5)
    @new_msg = New.order('created_at desc').first(5)
  end
  
  protected
  def week (fday = 0)
    @month_arr=["янв", "фев", "мар", "апр"]
    t = Time.now - 1.day + fday.days
    @wdays = []
    20.times do
      if a = Day.where(["day = ? and month = ? and year = ?", t.day, t.month, t.year]).last
        @wdays << a
      else
        @wdays << Day.new(:day => t.day, :month => t.month, :year => t.year)
      end
      t += 1.day
    end
  end
  
end
