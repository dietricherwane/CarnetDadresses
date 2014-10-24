class ForumThemesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!

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
end
