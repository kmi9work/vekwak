# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
