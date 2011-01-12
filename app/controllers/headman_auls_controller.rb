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
    if success and @headman_aul.errors.empty?
      respond_to do |rt|
        rt.html {redirect_back_or_default('/')}
        rt.js
      end
    else
      respond_to do |rt|
        rt.html {render :action => 'new'}
        rt.js {render 'fail_create.js.erb'}
      end
      
    end
  end
  
end
