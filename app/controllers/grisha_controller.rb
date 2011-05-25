class GrishaController < ApplicationController
  skip_before_filter :all
  layout false
  def index
  end
  def make_file
    require 'iconv'
    require 'unicode'
    str = Iconv.iconv('UTF-8', 'CP1251', params[:file].read)[0]
    @str = {}
    str.split(/[\s\.\,!:"';\?\d\(\)=\-\+ ]/u).each do |word|
      @str[Unicode.downcase(word)] ||= 0
      @str[Unicode.downcase(word)] += 1
    end
  end
end
