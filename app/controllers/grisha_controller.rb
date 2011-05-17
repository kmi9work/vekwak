class GrishaController < ApplicationController
  skip_before_filter :all
  layout false
  def index
  end
  def make_file
    str = params[:file].read
    @str = {}
    str.split(/[\s\.\,!:"';\?\d\(\)=\-\+ ]/).each do |word|
      @str[word] ||= 0
      @str[word] += 1
    end
  end
end
