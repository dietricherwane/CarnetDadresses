class ForumThemesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show, :api_create, :api_show_per_user]

  before_filter only: [:api_create] do |s| authenticate_user_from_token!(params[:authentication_token]) end
  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def index
    @forum_theme = ForumThemes.new
    @forum_themes = ForumThemes.all.page(params[:page]).per(10)
  end

  def create
    @forum_themes = ForumThemes.all.page(params[:page]).per(10)

    @forum_theme = ForumThemes.new(params[:forum_themes].merge(user_id: current_user.id, validated_by: (current_user.admin? ? current_user.id : nil), validated_at: (current_user.admin? ? DateTime.now : nil)))
    if @forum_theme.save
      @forum_theme = ForumThemes.new
      flash.now[:success] = "Le thème a été correctement créé."
    else
      flash.now[:error] = @forum_theme.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end

    render :index
  end

  def edit
    @forum_theme = ForumThemes.find_by_id(params[:id])
    @forum_themes = ForumThemes.all.page(params[:page]).per(10)

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
    my_hash = "["
    forum_themes.each do |forum_theme|
      my_hash << forum_theme.merge!(number_of_posts: (ForumThemes.find_by_id(forum_theme["id"]).forum_posts.count rescue 0)).except!(*api_fields_to_except).to_json << ","
    end
    my_hash = my_hash[0..(my_hash.length - 2)]
    my_hash << "]"

    render json: my_hash
  end

  def api_show_per_user
    forum_themes = ForumThemes.where("user_id = #{params[:user_id].to_i} AND published IS NOT FALSE").as_json
    my_hash = "["
    forum_themes.each do |forum_theme|
      my_hash << forum_theme.merge!(number_of_posts: (ForumThemes.find_by_id(forum_theme["id"]).forum_posts.count rescue 0)).except!(*api_fields_to_except).to_json << ","
    end
    my_hash = my_hash[0..(my_hash.length - 2)]
    my_hash << "]"

    render json: my_hash
  end

  def api_create
    forum_theme = ForumThemes.new(title: URI.unescape(params[:title]), content: URI.unescape(params[:content]), published: false, user_id: (User.find_by_authentication_token(params[:authentication_token]).id rescue nil))
    if forum_theme.save
      message = "[" << forum_theme.as_json.except(*api_fields_to_except).to_json << "]"
    else
      message = "[" << {errors: forum_theme.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join}.to_json.to_s << "]"
    end

    render json: message
  end

  def api_fields_to_except
    return ["published", "updated_at", "validated_by", "validated_at", "unpublished_by", "unpublished_at", "user_id", "sector_id", "sales_area_id"]
  end
end
