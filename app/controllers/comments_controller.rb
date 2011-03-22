class CommentsController < ApplicationController
  before_filter :login_required, :only => [:create, :destroy, :plus, :minus, :new]
  def new
    @comment = Comment.new
    if params[:post_id]
      @post_id = Post.find(params[:post_id]).id
    elsif params[:comment_id]
      @post_id = Comment.find(params[:comment_id]).post.id
    end
  end

  def list
    @comments = Comment.all.reverse    
    @comments = @comments.paginate :page => params[:page], :per_page => 16  
  end
    
  def create
    @comment = Comment.new(params[:comment])
    @comment.student = @student
    unless @comment.content.strip.empty?
      if params[:comment_id]
        comment = Comment.find(params[:comment_id])
        comment.comments << @comment
        @comment.comment = comment
        post = comment.post
        top_level = false
      elsif params[:post_id]
        post = Post.find(params[:post_id]) 
        top_level = true
      else 
        respond_to do |format|
          format.html{redirect_to :action => :new}
          format.js{render 'fail.js.erb', :locals => {:msg => "Wrong params!"}}
        end
        return
      end
      @comment.post = post
      post.comments << @comment
      if @comment.save
        respond_to do |format|
          format.html{redirect_to post}
          format.js{render 'create.js.erb', :locals => {:top_level => top_level}}
        end
      else
        respond_to do |format|
          format.html{redirect_to :action => :new}
          format.js{render 'fail.js.erb', :locals => {:msg => "Fail save."}}
        end
      end
    else
      respond_to do |format|
        format.html{redirect_to :action => :new}
        format.js{render 'fail.js.erb', :locals => {:msg => "Empty!"}}
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
        format.js{render 'fail.js.erb'}
      end
    end
  end
  def plus
    comment = Comment.find(params[:comment_id])
    if comment_rating_student = CommentRatingStudent.where(:comment_id => comment.id, :student_id => @student.id).first
      respond_to do |format|
        format.html {render :nothing => true}
        format.js {render :nothing => true}
      end
    else
      @comment_rating_student = CommentRatingStudent.new
      comment[:rating] +=1
      @rating = comment[:rating]
      @id = comment.id
      @comment_rating_student.mark = 1
      comment.comment_rating_students << @comment_rating_student
      comment.save
      @student.comment_rating_students << @comment_rating_student
      @student.save
      respond_to do |format|
        format.html {render :refresh}
        format.js {render 'ch_rating.js.erb'}
      end
    end
  end
  
  def minus
    comment = Comment.find(params[:comment_id])
    if comment_rating_student = CommentRatingStudent.where(:comment_id => comment.id, :student_id => @student.id).first
      respond_to do |format|
        format.html {render :nothing => true}
        format.js {render :nothing => true}
      end
    else
      @comment_rating_student = CommentRatingStudent.new
      comment[:rating] -=1
      @rating = comment[:rating]
      @id = comment.id
      @comment_rating_student.mark = -1
      comment.comment_rating_students << @comment_rating_student
      comment.save
      @student.comment_rating_students << @comment_rating_student
      @student.save
      respond_to do |format|
        format.html {render :refresh}
        format.js {render 'ch_rating.js.erb'}
      end
    end
  end
  def raters
    comment = Comment.find(params[:comment_id])
    @id = comment.id
    @raters = comment.comment_rating_students
    render :template => 'comments/raters', :layout => false
  end
end