class SectionsController < ApplicationController
  def list
    @sections = Section.find(:all)
    respond_to do |format|
      format.html # list.html.erb
      format.xml  { render :xml => @sections }
    end
  end

  # GET /sections/new
  # GET /sections/new.xml
  def new
    @section = Section.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @section }
    end
  end

  # GET /sections/1/edit
  def edit
    if @student.admin
      @section = Section.find(params[:id])
    else
      redirect_to :back or render :status => 403
    end
  end

  # POST /sections
  # POST /sections.xml
  def create
    if @student.admin or @student.headman
      @section = Section.new(params[:section])
      respond_to do |format|
        if @section.save
          flash[:notice] = 'Section was successfully created.'
          format.html { redirect_to topic }
          format.xml  { render :xml => @section, :status => :created, :location => @section }
        else
          flash[:notice] = 'Error.'
          format.html { render :action => "new" }
          format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
        end
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
      respond_to do |format|
        if @section.update_attributes(params[:section])
          flash[:notice] = 'Section was successfully updated.'
          format.html { redirect_to(topic) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to :back or render :status => 403
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.xml
  def destroy
    if @student.admin
      @section = Section.find(params[:id])
      topic = @section.topic
      @section.destroy
    
      respond_to do |format|
        format.html { redirect_to :back }
        format.xml  { head :ok }
      end
    else
      redirect_to :back or render :status => 403
    end
  end  
  
end
