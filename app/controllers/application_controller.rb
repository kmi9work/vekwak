# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :stud, :layout_work
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password  
  
  protected
  def stud
    @student = current_student
  end
  
  def layout_work
    @students = Student.all
    @sections = Section.all
    @students_online = Student.where('last_visit >= ?', Time.zone.now - 10.minutes)
    @new_message = @student.nil? ? 0 : @student.messages.collect{|p| p.new}.select{|x| x==true}.size
    @student.record_last_visit if @student
    info_msg
    week
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
          if comment.content =~ /<([^\s]+)\s.*>(.*)<\/\1>/
            comment.content = comment.content.gsub(/<([^\s]+)\s.*>(.*)<\/\1>/, "[#{$1}]")
          end
          comment.content = comment.content.gsub(/!http:\/\/.*\(.*\)!/, "[img]")
          @last_comments << comment
          i += 1
        end
      else
        if post.blinds.empty?
          if comment.content =~ /<([^\s]+)\s.*>(.*)<\/\1>/
            comment.content = comment.content.gsub(/<([^\s]+)\s.*>(.*)<\/\1>/, "[#{$1}]")
          end
          comment.content = comment.content.gsub(/!http:\/\/.*\(.*\)!/, "[img]")
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








