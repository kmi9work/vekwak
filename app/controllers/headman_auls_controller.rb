#encoding: utf-8
class HeadmanAulsController < ApplicationController
  before_filter :login_required, :only => [:create, :new]
  before_filter :headman?, :only => [:create]
  
  def index
    @auls = HeadmanAul.order('created_at desc').all
  end
  
  def new
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
        format.js {render 'layouts/fail.js.erb', :locals => {:msg => "Can't create :("}}
      end  
    end
  end
end
