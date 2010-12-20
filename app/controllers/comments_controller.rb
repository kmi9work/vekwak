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

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    if @student.admin or @comment.student.id == @student.id
      topic = @comment.topic or topic = @comment.comment.topic
      @comment.destroy
      redirect_to topic
    else
      render :status => 403
    end
  end
end
