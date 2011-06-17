class HistoryController < ApplicationController
  before_filter :logged_in?, :except => ["login", "new", "register", "create"]
  def logged_in?
    @huser = session[:huser] ? Huser.find(session[:huser]) : nil
    if @huser
      return true 
    elsif @student 
      @huser = Huser.where(:login => @student.login)[0] || 
               Huser.create(:login => @student.login, :name => "#{@student.name} #{@student.second_name[0].upcase}. #{@student.last_name[0].upcase}.")
      session[:huser] = @huser.id
      return true
    else
      redirect_to :new
    end
  end
    
  def huser_login
    if @huser = Huser.where(:login => params[:login], :password => params[:password])
      session[:huser] = @huser.id 
      redirect_to :index
    else
      redirect_to :new
    end
  end
  
  def new
  end
  
  def register
    @huser = Huser.new
  end
  
  def create
    puts params.inspect
    if params[:password] == params[:password_confirmation]
      @huser = Huser.create(params[:huser]) rescue @huser = nil
      if @huser
        session[:huser] = @huser.id
        redirect_to :index
      else
        render :register
      end
    else
      render :register
    end  
  end
end
#теория диалогов. Лотман, Бахтин, Библер...