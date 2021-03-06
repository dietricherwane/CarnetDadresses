class NewsFeedsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def index
    @news_feed = NewsFeed.new
    @news_feeds = NewsFeed.all.page(params[:page]).per(10)
  end

  def create
    @news_feeds = NewsFeed.all.page(params[:page]).per(10)

    if current_user.admin?
      params[:news_feed].merge!(published: false)
    end

    @news_feed = NewsFeed.new(params[:news_feed].merge(user_id: current_user.id))
    if @news_feed.save
      @news_feed = NewsFeed.new
      flash.now[:success] = "L'Actualité a été correctement créée."
    else
      flash.now[:error] = @news_feed.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end

    render :index
  end

  def edit
    @news_feed = NewsFeed.find_by_id(params[:id])
    @news_feeds = NewsFeed.all.page(params[:page]).per(10)

    unless @news_feed
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def update
    @news_feed = NewsFeed.find_by_id(params[:id])
    if @news_feed.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @news_feed.update_attributes(params[:news_feed])
      @news_feed.errors.full_messages.blank? ? flash.now[:success] = "L'Actualité a été mise à jour." : flash.now[:error] = @news_feed.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      @news_feeds = NewsFeed.all.page(params[:page]).per(10)

      render :edit, id: @news_feed.id
    end
  end

  def disable_news_feed
    enable_disable_news_feed("désactivée", false)
  end

  def enable_news_feed
    enable_disable_news_feed("activée", true)
  end

  def enable_disable_news_feed(message, status)
    @news_feed = NewsFeed.find_by_id(params[:id])
    if @news_feed.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @news_feed.update_attributes(published: status)
      flash[:success] = "L'Actualité a été #{message}."

      redirect_to "/news_feeds"
    end
  end

  def api_show
    news_feeds = NewsFeed.where("published IS NOT FALSE").limit(5).as_json
    my_hash = api_render_several_objects(news_feeds, {}, ["user_id", "published", "picture", "created_at", "updated_at"])

    render json: my_hash
  end

end
