class ForumThemesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show, :api_create, :api_show_per_user]

  before_filter only: [:api_create] do |s| authenticate_user_from_token!(params[:authentication_token]) end
  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def index
    @forum_theme = ForumThemes.new
    @sales_areas = SalesArea.where(published: [nil, true])
    @forum_themes = ForumThemes.all.page(params[:page]).per(10)
    @jobs = AdressBook.unscoped.select("DISTINCT job_role")
  end

  def create
    @forum_themes = ForumThemes.all.page(params[:page]).per(10)
    @sales_areas = SalesArea.where(published: [nil, true])
    @jobs = AdressBook.unscoped.select("DISTINCT job_role")
    @forum_theme = ForumThemes.new(params[:forum_themes].merge(user_id: current_user.id, validated_by: (current_user.admin? ? current_user.id : nil), validated_at: (current_user.admin? ? DateTime.now : nil)))

    if params[:forum_themes][:job_category].blank? && params[:forum_themes][:sales_area_id].blank?
      @forum_theme.errors[:base] << "Veuillez choisir une catégorie professionnelle ou un domaine d'activités."
      flash.now[:error] = @forum_theme.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    else
      if @forum_theme.save
        # Notification email
        unless supadmins.blank?
          AdminNotification.new_forum(supadmins.map{ |sa| sa.email}, @forum_theme).deliver
        end

        @forum_theme = ForumThemes.new
        flash.now[:success] = "Le thème a été correctement créé."
      else
        flash.now[:error] = @forum_theme.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
    end

    render :index
  end

  def edit
    @forum_theme = ForumThemes.find_by_id(params[:id])
    @forum_themes = ForumThemes.all.page(params[:page]).per(10)
    @sales_areas = SalesArea.where(published: [nil, true])
    @sub_sales_areas = @forum_theme.sales_area.sub_sales_areas rescue []
    @jobs = AdressBook.unscoped.select("DISTINCT job_role")

    unless @forum_theme
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def update
    @forum_theme = ForumThemes.find_by_id(params[:id])

    if @forum_theme.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @forum_theme.update_attributes(params[:forum_themes])
      @forum_theme.errors.full_messages.blank? ? flash.now[:success] = "Le thème a été mis à jour." : flash.now[:error] = @forum_theme.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      @forum_themes = ForumThemes.all.page(params[:page]).per(10)
      @sales_areas = SalesArea.where(published: [nil, true])
      @sub_sales_areas = @forum_theme.sales_area.sub_sales_areas rescue []
      @jobs = AdressBook.unscoped.select("DISTINCT job_role")

      render :edit, id: @forum_theme.id
    end
  end

  def disable_forum_theme
    enable_disable_forum_theme("désactivé", false)
  end

  def enable_forum_theme
    enable_disable_forum_theme("activé", true)
  end

  def enable_disable_forum_theme(message, status)
    @forum_theme = ForumThemes.find_by_id(params[:id])
    if @forum_theme.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @forum_theme.update_attributes(published: status, validated_by: (status ? current_user.id : false), validated_at: (status ? DateTime.now : nil), unpublished_by: (status ? nil : current_user.id), unpublished_at: (status ? nil : DateTime.now))
      flash[:success] = "Le thème a été #{message}."

      redirect_to "/forum_themes"
    end
  end

  def forum_posts
    @forum_theme = ForumThemes.find_by_id(params[:id])
    if @forum_theme.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @forum_posts = @forum_theme.forum_posts.page(params[:page]).per(10)
    end
  end

  def api_show
    forum_themes = ForumThemes.where("published IS NOT FALSE").as_json
    my_hash = "{"'"data"'":["
    forum_themes.each do |forum_theme_object|
      @forum_theme = ForumThemes.find_by_id(forum_theme_object["id"])
      my_hash << forum_theme_object.merge!(api_fields_to_merge).except!(*api_fields_to_except).to_json << ","
    end
    my_hash = my_hash[0..(my_hash.length - 2)]
    my_hash << "]}"

    render json: my_hash
  end

  def api_show_per_user
    forum_themes = ForumThemes.where("user_id = #{params[:user_id].to_i} AND published IS NOT FALSE").as_json
    my_hash = "{"'"data"'":["
    forum_themes.each do |forum_theme_object|
      @forum_theme = ForumThemes.find_by_id(forum_theme_object["id"])
      my_hash << forum_theme_object.merge!(api_fields_to_merge).except!(*api_fields_to_except).to_json << ","
    end
    my_hash = my_hash[0..(my_hash.length - 2)]
    my_hash << "]}"

    render json: my_hash
  end

  def api_create
    @forum_theme = ForumThemes.new(title: URI.unescape(params[:title]), job_category: URI.unescape(params[:job_category]), sales_area_id: params[:sales_area_id].to_i, sub_sales_area_id: params[:sub_sales_area_id].to_i, content: URI.unescape(params[:content]), published: false, user_id: (User.find_by_authentication_token(params[:authentication_token]).id rescue nil))
    if @forum_theme.save
      # Notification email
      unless supadmins.blank?
        AdminNotification.new_forum(supadmins.map{ |sa| sa.email}, @forum_theme).deliver
      end
      message = "{"'"data"'":[" << @forum_theme.as_json.merge!(api_fields_to_merge).except(*api_fields_to_except).to_json << "]}"
    else
      message = "{"'"data"'":[" << {errors: @forum_theme.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join}.to_json.to_s << "]}"
    end

    render json: message
  end

  def api_fields_to_except
    return ["published", "updated_at", "validated_by", "validated_at", "unpublished_by", "unpublished_at", "sector_id", "sales_area_id", "sub_sales_area_id"]
  end

  def api_fields_to_merge
    return {number_of_posts: (@forum_theme.forum_posts.count rescue 0), posted_by: (@forum_theme.user.full_name rescue nil), sales_area: (@forum_theme.sales_area.name rescue nil), sub_sales_area: (@forum_theme.sub_sales_area.name rescue nil)}
  end
end
