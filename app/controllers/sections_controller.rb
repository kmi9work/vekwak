class SectionsController < ApplicationController
  def list
    @sections = Section.find(:all)
  end

  # GET /sections/new
  # GET /sections/new.xml
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
    if @student.admin
      @section = Section.find(params[:id])
    else
      render :status => 403
    end
  end

  # POST /sections
  # POST /sections.xml
  def create
    if @student.admin or @student.headman
      @section = Section.new(params[:section])
      if @section.save
        flash[:notice] = 'Section was successfully created.'
        redirect_to topic
      else
        flash[:notice] = 'Error.'
        render :action => "new"
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.xml
  def update
    if @student.admin
      @section = Section.find(params[:id])
      section = @section
      while !section.topic
        section = section.section
      end
      topic = section.topic 
      if @section.update_attributes(params[:section])
        flash[:notice] = 'Section was successfully updated.'
        redirect_to(topic)
      else
        render :action => "edit"
      end
    else
      render :status => 403
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.xml
  def destroy
    if @student.admin
      @section = Section.find(params[:id])
      topic = @section.topic
      @section.destroy
      redirect_back_or_default('/') 
    else
      render :status => 403
    end
  end  
  
end
