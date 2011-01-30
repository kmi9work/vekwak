#encoding: utf-8
class HeadmanAulsController < ApplicationController
  def index
    @auls = HeadmanAul.order('created_at desc').all
  end
  
  def new
    @headman_aul = HeadmanAul.new
  end
  
  def create
    @headman_aul = HeadmanAul.create(params[:headman_aul])
    success = @headman_aul && @headman_aul.save
    info_msg
    if success and @headman_aul.errors.empty?
      respond_to do |format|
        format.html {redirect_back_or_default('/')}
        format.js
      end
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.js {render 'fail_create.js.erb'}
      end  
    end
  end
end
