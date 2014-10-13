class HoldingsController < ApplicationController
   #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @holding = Holding.new
    @countries = Country.all
    @holdings = Holding.all.page(params[:page]).per(10) 
  end
  
  def create
    @holdings = Holding.all.page(params[:page]).per(10)
    @countries = Country.all
    
    @holding = Holding.new(params[:holding].merge(user_id: current_user.id))
    if @holding.save
      @holding = Holding.new
      flash.now[:success] = "Le groupe a été correctement créée."
    else
      flash.now[:error] = @holding.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join  
    end
    
    render :index
  end
  
  def edit
    @holding = Holding.find_by_id(params[:id])
    @countries = Country.all
    @holdings = Holding.all.page(params[:page]).per(10)
    
    unless @holding
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end  
  end
  
  def update
    @holding = Holding.find_by_id(params[:id])
    if @holding.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      @holding.update_attributes(params[:holding])
      @holding.errors.full_messages.blank? ? flash.now[:success] = "Le groupe a été mis à jour." : flash.now[:error] = @holding.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      @holdings = Holding.all.page(params[:page]).per(10)
      @countries = Country.all
       
      render :edit, id: @holding.id
    end 
  end
  
  def disable_holding
    enable_disable_holding("désactivé", false)
  end
  
  def enable_holding
    enable_disable_holding("activé", true)
  end
  
  def enable_disable_holding(message, status)
    @holding = Holding.find_by_id(params[:id])
    if @holding.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      @holding.update_attributes(published: status)
      flash[:success] = "Le Groupe a été #{message}." 
               
      @holdings = Holding.all.page(params[:page]).per(10)
      
      redirect_to "/holdings"
    end 
  end
  
  def companies
    @holding = Holding.find_by_id(params[:id])    
    if @holding.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @adress_books = @holding.adress_books.page(params[:page]).per(10) 
      @countries = Country.all
    end
  end
  
end
