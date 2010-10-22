class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.find(:all, :limit => 10, :order => 'rating desc')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])
    p params
    @comments = Comment.find_by_topic_id(params[:id]) or @comments = []
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    unless @student.admin or @student.id == @topic.student.id
      redirect_to :back or render :status => 403
    end
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.student = @student
    respond_to do |format|
      @topic.rating = 0
      if @topic.save
        
        flash[:notice] = 'Topic was successfully created.'
        format.html { redirect_to(@topic) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])
    if @student.admin or @student.id == @topic.student.id
      respond_to do |format|
        if @topic.update_attributes(params[:topic])
          flash[:notice] = 'Topic was successfully updated.'
          format.html { redirect_to(@topic) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to :back or render :status => 403
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    if @student.admin or @student.id == @topic.student.id
      @topic.destroy

      respond_to do |format|
        format.html { redirect_to(topics_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to :back or render :status => 403
    end
  end
  
  def plus
    respond_to do |wants|
      wants.js do 
        topic = Topic.find(params[:id])
        if topic_rating_student = TopicRatingStudent.find(:first, :conditions => {:topic_id => topic.id, :student_id => @student.id})
          topic_rating_student.mark += 1
          topic_rating_student.save
          render :text => topic[:rating].to_s
        else
          topic_rating_student = TopicRatingStudent.new
          topic[:rating] +=1
          topic_rating_student.mark = 1
          topic.topic_rating_students << topic_rating_student
          topic.save
          @student.topic_rating_students << topic_rating_student
          @student.save
          render :text => topic[:rating].to_s
        end
      end
      wants.html do
        topic = Topic.find(params[:id])
        topic[:rating] +=1
        topic.save
        render :refresh
      end
    end
  end
  
  def minus
    respond_to do |wants|
      wants.js do 
        topic = Topic.find(params[:id])
        if topic_rating_student = TopicRatingStudent.find(:first, :conditions => {:topic_id => topic.id, :student_id => @student.id})
          topic_rating_student.mark -= 1
          topic_rating_student.save
          render :text => topic[:rating].to_s
        else
          topic_rating_student = TopicRatingStudent.new
          topic[:rating] -=1
          topic_rating_student.mark = -1
          topic.topic_rating_students << topic_rating_student
          topic.save
          @student.topic_rating_students << topic_rating_student
          @student.save
          render :text => topic[:rating].to_s
        end
      end
      wants.html do
        topic = Topic.find(params[:id])
        topic[:rating] -=1
        topic.save
        render :refresh
      end
    end
  end
  def topic_raters
    topic = Topic.find(params[:id])
    @topic_raters = topic.topic_rating_students
    render :template => 'topics/topic_raters', :layout => false
  end
  
  def sections
    @sections = Section.find(:all)
  end
  
  
end









