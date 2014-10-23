class SalesAreasController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!

  layout :layout_used

  def index
    @sales_area = SalesArea.new
    @sales_areas = SalesArea.all.page(params[:page]).per(10)
  end

  def create
    @sales_areas = SalesArea.all.page(params[:page]).per(10)

    @sales_area = SalesArea.new(params[:sales_area].merge(user_id: current_user.id))
    if @sales_area.save
      @sales_area = SalesArea.new
      flash.now[:success] = "Le Domaine d'Activités a été correctement créée."
    else
      flash.now[:error] = @sales_area.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end

    render :index
  end

  def edit
    @sales_area = SalesArea.find_by_id(params[:id])
    @sales_areas = SalesArea.all.page(params[:page]).per(10)

    unless @sales_area
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def update
    @sales_area = SalesArea.find_by_id(params[:id])
    if @sales_area.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @sales_area.update_attributes(params[:sales_area])
      @sales_area.errors.full_messages.blank? ? flash.now[:success] = "Le Domaine d'Activités a été mise à jour." : flash.now[:error] = @sales_area.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      @sales_areas = SalesArea.all.page(params[:page]).per(10)

      render :edit, id: @sales_area.id
    end
  end

  def disable_sales_area
    disable_enable_sales_area("désactivé", false)
  end

  def enable_sales_area
    disable_enable_sales_area("activé", true)
  end

  def disable_enable_sales_area(message, status)
    @sales_area = SalesArea.find_by_id(params[:id])
    if @sales_area.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @sales_area.update_attributes(published: status)
      flash[:success] = "Le Domaine d'Activités a été #{message}."

      @sales_areas = SalesArea.all.page(params[:page]).per(10)

      redirect_to :back
    end
  end

  def sub_sales_areas
    @sub_sales_areas_options = "<select id = 'company_sub_sales_area_id' class = 'form-control' name = 'company[sub_sales_area_id]'><option>-Veuillez choisir un sous domaine-</option>"
    @sub_sales_areas = SubSalesArea.where("sales_area_id = #{params.first.first.to_s.to_i}")
    unless @sub_sales_areas.blank?
      @sub_sales_areas.each do |sub_sales_area|
        @sub_sales_areas_options << "<option value='#{sub_sales_area.id}'>#{sub_sales_area.name}</option>"
      end
    end
    render :text => @sub_sales_areas_options << "</select>"
  end
end
