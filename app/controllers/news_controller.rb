class NewsController < ApplicationController
  def index
    @news = New.order('created_at desc').all
  end
  
  def new
  end
  
  def create
    @new = New.create(params[:new])
    @new.student = @student
    success = @new && @new.save
    info_msg
    if success and @new.errors.empty?
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
