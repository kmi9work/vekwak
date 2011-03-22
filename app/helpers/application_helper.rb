# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def admin_or_me?(id)
    @student and (@student.admin or @student.id == id)
  end
  
  def admin?
    @student and @student.admin
  end
  
  def headman?
    @student and @student.headman
  end
  
  def admin_or_headman?
    @student and (@student.admin or @student.headman)
  end
  
  def me?(id)
     @student and @student.id == id
  end
  
  def font_color (a)
    if a > 0
      "green"
    elsif a == 0
      "gray"
    else
      "red"
    end
  end
end
