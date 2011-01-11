class CommentsController < ApplicationController

  def new
    @comment = Comment.new
    if params[:topic_id]
      @topic_id = Topic.find(params[:topic_id]).id
    elsif params[:comment_id]
      @topic_id = Comment.find(params[:comment_id]).topic.id
    end
    
    # respond_to  do |t|
    #       t.js do 
    #         
    #       end
    #       t.html do
    #         @comment = Comment.new
    #         if params[:topic_id]
    #           @topic_id = Topic.find(params[:topic_id]).id
    #         elsif params[:comment_id]
    #           @topic_id = Comment.find(params[:comment_id]).topic.id
    #         end
    #         render :new
    #       end
    #     end
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.student = @student
    unless @comment.content.empty?
      if params[:topic_id]
        topic = Topic.find(params[:topic_id]) 
        @comment.topic = topic
        topic.comments << @comment
        if @comment.save
          flash[:notice] = 'Comment was successfully created.'
          redirect_to topic
        else
          flash[:notice] = 'smth wrong with save :('
          redirect_to :action => :new
        end
      elsif params[:comment_id]
        comment = Comment.find(params[:comment_id])
        comment.comments << @comment
        @comment.comment = comment
        topic = comment.topic
        if @comment.save
          flash[:notice] = 'Comment was successfully created.'
          redirect_to topic
        else
          flash[:notice] = 'smth wrong with save :('
          redirect_to :action => :new
        end
      else
        flash[:notice] = 'Something wrong!'
        redirect_to :action => :new
      end
    else
      flash[:notice] = 'Do not empty!'
      redirect_to :action => :new
    end
  end

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
