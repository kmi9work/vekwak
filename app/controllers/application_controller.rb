# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :layout_work, :stud
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password  
  
  protected
  def layout_work
    @students = Student.all
    @sections = Section.all
    @students_online = Student.where('last_visit >= ?', 10.minutes.ago)
    @new_message = @student.nil? ? 0 : @student.messages.collect{|p| p.new}.select{|x| x==true}.size
    info_msg
    week
  end
  
  def stud
    @student = current_student
  end
  
  def info_msg
    @headman_msg = HeadmanAul.order('created_at desc').first(5)
    @last_comments = []
    i = 0
    Comment.order('created_at desc').each do |comment|
      break if i >= 5
      post = comment.post || comment.comment.post
      unless @stundent.nil?
        if post.blinds.all? {|blind| @student.id != blind.student_id}
          @last_comments << comment
          i += 1
        end
      else
        if post.blinds.empty?
          @last_comments << comment
          i += 1
        end
      end
    end
    @novelty_msg = Novelty.order('created_at desc').first(5)
  end
  
  def week (fday = 0)
    @month_arr=["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "нояб", "дек"]
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
  def student?
    !!@student
  end
  
  def admin?
    !!@student.admin
  end
  
  def headman?
    !!@student.headman
  end
end








