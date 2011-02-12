class PostsController < ApplicationController
  def index  
    if params[:section_id]
      @posts1=Post.all :order => 'created_at DESC', :conditions => ["section_id ==?", params[:section_id]]
    else
      @posts1=Post.all :order => 'created_at DESC'
    end
    @posts2=[]
    @posts1.each do |post|
      post.blinds.each do |blind|
        (@posts2<<post) if blind.student_id==@student.id
      end
    end
    @posts1=@posts1-@posts2            
    @posts = @posts1.paginate :page => params[:page], :per_page => 6    
  end

  def show
    @post = Post.find(params[:id])
    @blinds=[]
    @post.blinds.each do |blind|
      redirect_to "/" if blind.student_id==@student.id
      @blinds<<Student.find_by_id(blind.student_id).name
    end
    @comments = @post.comments.reject{|i| i.comment_id}
  end

  def new
    @post = Post.new
    @sections = Section.all.collect {|s| [ s.title, s.id ] }
    @students_list = Student.all.collect {|s| [ s.name, s.id ] }
  end
  
  def new_big
    @post ||= Post.new
    @sections = Section.all.collect {|s| [ s.title, s.id ] }
    @students_list = Student.all.collect {|s| [ s.name, s.id ] }
  end

  def edit
    @post = Post.find(params[:id])
    @students_list = Student.all.collect {|s| [ s.name, s.id ] }
    unless @student.admin or @student.id == @post.student.id
      render :status => 403
    end
  end

  def create
    @post = Post.new(params[:post])
    @post.student = @student
    @post.rating = 0
    (Student.all-[@student]).each do |stud|
      puts "this------------"
      puts params["#{stud.id}"]
      if params["#{stud.id}"]=="1"
        a=Blind.new        
        a.student_id=stud.id
        @post.blinds << a
        a.save
      end
    end
    if @post.save
      respond_to do |rt|
        rt.html {redirect_to(@post)}
        rt.js
      end
    else
      respond_to do |rt|
        rt.html {render :action => "new"}
        rt.js {render 'fail_create.js.erb'}
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    if @student.admin or @student.id == @post.student.id
      if @post.update_attributes(params[:post])
        redirect_to @post
      else
        render :action => "edit"
      end
    else
      render :status => 403
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @student.admin or @student.id == @post.student.id
      @post.destroy
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
    post = Post.find(params[:post_id])
    if post_rating_student = PostRatingStudent.where(:post_id => post.id, :student_id => @student.id).first
      post_rating_student.mark += 1
      post_rating_student.save
      respond_to do |format|
        format.html {render :refresh}
        format.js {render :nothing => true}
      end
    else
      post_rating_student = PostRatingStudent.new
      post[:rating] +=1
      @rating = post[:rating]
      @id = post.id
      post_rating_student.mark = 1
      post.post_rating_students << post_rating_student
      post.save
      @student.post_rating_students << post_rating_student
      @student.save
      respond_to do |format|
        format.html {render :refresh}
        format.js {render 'ch_rating.js.erb'}
      end
    end
  end
  
  def minus
    post = Post.find(params[:post_id])
    if post_rating_student = PostRatingStudent.where(:post_id => post.id, :student_id => @student.id).first
      post_rating_student.mark -= 1
      post_rating_student.save
      respond_to do |format|
        format.html {render :refresh}
        format.js {render :nothing => true}
      end
    else
      post_rating_student = PostRatingStudent.new
      post[:rating] -=1
      @rating = post[:rating]
      @id = post.id
      post_rating_student.mark = -1
      post.post_rating_students << post_rating_student
      post.save
      @student.post_rating_students << post_rating_student
      @student.save
      respond_to do |format|
        format.html {render :refresh}
        format.js {render 'ch_rating.js.erb'}
      end
    end
  end
  def raters
    post = Post.find(params[:post_id])
    @id = post.id
    @raters = post.post_rating_students
    render :template => 'posts/raters', :layout => false
  end
  
  def sections
    @sections = Section.find(:all)
  end
end









