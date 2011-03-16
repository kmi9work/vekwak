class NoveltiesController < ApplicationController
  def index
    @novelties = Novelty.order('created_at desc').all
  end
  
  def new
  end
  
  def create
    @novelty = Novelty.create(params[:novelty])
    @novelty.student = @student
    success = @novelty && @novelty.save
    info_msg
    if success and @novelty.errors.empty?
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
