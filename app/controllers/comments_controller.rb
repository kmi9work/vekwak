class CommentsController < ApplicationController

  def new
    @comment = Comment.new
    if params[:post_id]
      @post_id = Post.find(params[:post_id]).id
    elsif params[:comment_id]
      @post_id = Comment.find(params[:comment_id]).post.id
    end
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.student = @student
    unless @comment.content.strip.empty?
      if params[:post_id]
        post = Post.find(params[:post_id]) 
        @comment.post = post
        post.comments << @comment
        if @comment.save
          #created.
          respond_to do |format|
            format.html{redirect_to post}
            format.js{render 'create.js.erb', :locals => {:top_level => true}}
          end
        else
          # smth wrong with save :(
          respond_to do |format|
            format.html{redirect_to :action => :new}
            format.js{render 'fail_create.js.erb', :locals => {:msg => "Fail save."}}
          end
        end
      elsif params[:comment_id]
        comment = Comment.find(params[:comment_id])
        comment.comments << @comment
        @comment.comment = comment
        post = comment.post
        if @comment.save
          flash[:notice] = 'Comment was successfully created.'
          respond_to do |format|
            format.html{redirect_to post}
            format.js{render 'create.js.erb', :locals => {:top_level => false}}
          end
        else
          flash[:notice] = 'smth wrong with save :('
          respond_to do |format|
            format.html{redirect_to :action => :new}
            format.js{render 'fail_create.js.erb', :locals => {:msg => "Fail save."}}
          end
        end
      else
        flash[:notice] = 'Something wrong!'
        respond_to do |format|
          format.html{redirect_to :action => :new}
          format.js{render 'fail_create.js.erb', :locals => {:msg => "Wrong params!"}}
        end
      end
    else
      respond_to do |format|
        format.html{redirect_to :action => :new}
        format.js{render 'fail_create.js.erb', :locals => {:msg => "Empty!"}}
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if @student.admin or comment.student.id == @student.id
      if comment.post
        post = comment.post
        @top_level = true
      else
        post = comment.comment.post
        @top_level = false
      end
      @id = params[:id]
      comment.destroy
      respond_to do |format| 
        format.html{redirect_to post} 
        format.js 
      end 
    else
      respond_to do |format| 
        format.html{render :nothing, :status => 403} 
        format.js{render 'fail_destroy.js.erb'}
      end
    end
  end
end
