class SectionsController < ApplicationController
  before_filter :login_required, :only => [:new, :edit, :create, :destroy, :update]
  before_filter :admin?, :only => [:new, :edit, :create, :destroy, :update]
  def index
    @sections = Section.all
  end

  def new
    @section = Section.new
  end

  def edit
    @section = Section.find(params[:id])
  end
  
  def show
    @sections = Section.all
  end

  def create
    @section = Section.new(params[:section])
    if @section.save
      flash[:notice] = 'Section was successfully created.'
      redirect_back_or_default '/'
    else
      flash[:notice] = 'Error.'
      render :action => "new"
    end
  end

  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
      flash[:notice] = 'Section was successfully updated.'
      redirect_back_or_default '/'
    else
      render :action => "edit"
    end
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    redirect_back_or_default('/') 
  end  

end
