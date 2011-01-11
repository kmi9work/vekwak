#encoding: utf-8
class HeadmanAulsController < ApplicationController
  def index
    @auls = HeadmanAul.order('created_at desc').all
  end
  
  def new
    @headman_aul = HeadmanAul.new
  end
  
  def create
    @headman_aul = HeadmanAul.create(params[:headman_aul])
    success = @headman_aul && @headman_aul.save
    if success and @headman_aul.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = 'ready'#"Готово ёма."
    else
      flash[:error]  = 'error'#"Эй! Ты что-то накосячил! Ну или это у нас проблемы... Попробуй ещё разок."
      render :action => 'new'
    end
  end
  
end
