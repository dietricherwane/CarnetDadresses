class HoldingsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def index
    @holding = Holding.new
    @countries = Country.all
    @holdings = Holding.all.page(params[:page]).per(10)
  end

  def create
    @holdings = Holding.all.page(params[:page]).per(10)
    @countries = Country.all

    @holding = Holding.new(params[:holding].merge(user_id: current_user.id, country_id: Country.find_by_name("Côte D'ivoire").id))
    if @holding.save
      @holding = Holding.new
      flash.now[:success] = "Le groupe a été correctement créée."
    else
      flash.now[:error] = @holding.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end

    render :index
  end

  def js_create
    @holding = Holding.new(params[:holding].merge(user_id: current_user.id, country_id: Country.find_by_name("Côte D'ivoire").id))
    respond_to do |format|
      if @holding.save
        format.js   { render text: "ok", status: 200 }
      else
        format.js   { render json: @holding.errors, status: :unprocessable_entity }
      end
    end
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
      @companies = @holding.companies.page(params[:page]).per(10)
      @countries = Country.all
    end
  end

  def get_holdings
    @holdings_options = "<select id = 'company_holding_id' class = 'form-control' name = 'company[holding_id]'><option>-Veuillez choisir un groupe-</option>"
    @holdings = Holding.where(validated_by: [nil, true], published: [nil, true])
    unless @holdings.blank?
      @holdings.each do |holding|
        @holdings_options << "<option value='#{holding.id}'>#{holding.name}</option>"
      end
    end
    render :text => @holdings_options << "</select>"
  end

  def api_show
    holding = Holding.find_by_id(params[:id]).as_json

    if holding
      holding = "[" << holding.except!(*["published", "updated_at", "created_at", "id", "user_id", "created_by", "validated_by"]).to_json << "]"
    else
      holding = []
    end

    render json: holding
  end

end
