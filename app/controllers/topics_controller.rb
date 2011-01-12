class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.find(:all, :limit => 10, :order => 'rating desc')
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])
    @comments = @topic.comments
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new
    @sections = Section.all.collect {|s| [ s.title, s.id ] }
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    unless @student.admin or @student.id == @topic.student.id
      render :status => 403
    end
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.student = @student
    @topic.rating = 0
    if @topic.save
      respond_to do |rt|
        rt.html {redirect_to(@topic)}
        rt.js
      end
    else
      respond_to do |rt|
        rt.html {render :action => "new"}
        rt.js {render 'fail_create.js.erb'}
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])
    if @student.admin or @student.id == @topic.student.id
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        redirect_to @topic
      else
        render :action => "edit"
      end
    else
      render :status => 403
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    if @student.admin or @student.id == @topic.student.id
      @topic.destroy
      redirect_back_or_default("/")
    else
      render :status => 403
    end
  end
#AJAX
  def write_comment
    render :text => "lalala", :layout => false
  end
  
  def plus
    respond_to do |wants|
      wants.js do 
        topic = Topic.find(params[:id])
        if topic_rating_student = TopicRatingStudent.where(:topic_id => topic.id, :student_id => @student.id).first
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
        if topic_rating_student = TopicRatingStudent.where(:topic_id => topic.id, :student_id => @student.id).first
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









