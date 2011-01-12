class CommentsController < ApplicationController

  def new
    @comment = Comment.new
    if params[:topic_id]
      @topic_id = Topic.find(params[:topic_id]).id
    elsif params[:comment_id]
      @topic_id = Comment.find(params[:comment_id]).topic.id
    end
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
          #created.
          respond_to do |rt|
            rt.html{redirect_to topic}
            rt.js{render 'create.js.erb', :locals => {:top_level => true}}
          end
        else
          # smth wrong with save :(
          respond_to do |rt|
            rt.html{redirect_to :action => :new}
            rt.js{render 'fail_create.js.erb', :locals => {:msg => "Fail save."}}
          end
        end
      elsif params[:comment_id]
        comment = Comment.find(params[:comment_id])
        comment.comments << @comment
        @comment.comment = comment
        topic = comment.topic
        if @comment.save
          flash[:notice] = 'Comment was successfully created.'
          respond_to do |rt|
            rt.html{redirect_to topic}
            rt.js{render 'create.js.erb', :locals => {:top_level => false}}
          end
        else
          flash[:notice] = 'smth wrong with save :('
          respond_to do |rt|
            rt.html{redirect_to :action => :new}
            rt.js{render 'fail_create.js.erb', :locals => {:msg => "Fail save."}}
          end
        end
      else
        flash[:notice] = 'Something wrong!'
        respond_to do |rt|
          rt.html{redirect_to :action => :new}
          rt.js{render 'fail_create.js.erb', :locals => {:msg => "Wrong params!"}}
        end
      end
    else
      respond_to do |rt|
        rt.html{redirect_to :action => :new}
        rt.js{render 'fail_create.js.erb', :locals => {:msg => "Empty!"}}
      end
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
