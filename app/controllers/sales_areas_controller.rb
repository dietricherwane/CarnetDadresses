class SalesAreasController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show, :api_list, :api_sub_sales_areas]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

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

      redirect_to sales_areas_path
    end
  end

  def companies_sub_sales_areas
    sub_sales_areas("company")
  end

  def forum_themes_sub_sales_areas
    sub_sales_areas("forum_themes")
  end

  def sub_sales_areas(model_name)
    @sub_sales_areas_options = "<select id = '#{model_name}_sub_sales_area_id' class = 'form-control' name = '#{model_name}[sub_sales_area_id]'><option>-Veuillez choisir un sous domaine-</option>"
    @sub_sales_areas = SubSalesArea.where("sales_area_id = #{params.first.first.to_s.to_i}")
    unless @sub_sales_areas.blank?
      @sub_sales_areas.each do |sub_sales_area|
        @sub_sales_areas_options << "<option value='#{sub_sales_area.id}'>#{sub_sales_area.name}</option>"
      end
    end
    render :text => @sub_sales_areas_options << "</select>"
  end

  def api_show
    sales_area = SalesArea.find_by_id(params[:id]).as_json
    my_hash = api_render_object(sales_area, {}, api_fields_to_except)

    render json: my_hash
  end

  def api_list
    sales_areas = SalesArea.where("published IS NOT FALSE").as_json
    my_hash = api_render_several_objects(sales_areas, {}, api_fields_to_except)

    render json: my_hash
  end

  def api_sub_sales_areas
    sub_sales_areas = SubSalesArea.where("published IS NOT FALSE AND sales_area_id = #{params[:sales_area_id].to_i}").as_json
    my_hash = api_render_several_objects(sub_sales_areas, {}, api_fields_to_except)

    render json: my_hash
  end

  def api_fields_to_except
    return ["published", "user_id", "created_at", "updated_at", "sales_area_id"]
  end
end
