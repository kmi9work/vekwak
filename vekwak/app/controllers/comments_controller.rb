class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def list
    @comments = Comment.find_all_by_topic_id(params[:topic_ix])
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    if @student.admin
      @comment = Comment.find(params[:id])
      comment = @comment
      while !comment.topic
        comment = comment.comment
      end
      @topic = comment.topic
    else
      render :status => 403
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    topic = Topic.find(params[:topic_id])
    @comment = Comment.new(params[:comment])
    unless @comment.content.empty?
      @comment.student = @student
      if params[:comment_id]
        comment = Comment.find(params[:comment_id])
        comment.comments << @comment
        @comment.comment = comment
      else
        @comment.topic = topic
        topic.comments << @comment
      end
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        redirect_to topic
      else
        if params[:comment_id]
          comment.comments.pop
        else
          topic.comments.pop
        end
        flash[:notice] = 'Error.'
        render :action => "new"
      end
    else
      redirect_to topic
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    if @student.admin
      @comment = Comment.find(params[:id])
      comment = @comment
      while !comment.topic
        comment = comment.comment
      end
      topic = comment.topic 
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        redirect_to topic
      else
        render :action => "edit"
      end
    else
      render :status => 403
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    if @student.admin
      @comment = Comment.find(params[:id])
      topic = @comment.topic
      @comment.destroy
      redirect_to :back
    else
      render :status => 403
    end
  end
end
