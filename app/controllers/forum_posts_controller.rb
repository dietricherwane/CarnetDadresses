class ForumPostsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def disable_forum_post
    enable_disable_forum_post("désactivé", false)
  end

  def enable_forum_post
    enable_disable_forum_post("activé", true)
  end

  def enable_disable_forum_post(message, status)
    @forum_post = ForumPost.find_by_id(params[:id])
    if @forum_post.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @forum_post.update_attributes(published: status, unpublished_by: (status ? nil : current_user.id), unpublished_at: (status ? nil : DateTime.now))
      flash[:success] = "Le post a été #{message}."

      redirect_to forum_theme_posts_path(@forum_post.forum_themes_id)
    end
  end

  def api_list
    forum_posts = ForumPost.where("forum_themes_id = #{params[:forum_theme_id].to_i} AND published IS NOT FALSE").as_json
    my_hash = "["
    forum_posts.each do |forum_post|
      my_hash << forum_post.except!(*["published", "created_by", "unpublished", "unpublished_by", "unpublished_at", "updated_at", "forum_themes_id"]).to_json << ","
    end
    my_hash = my_hash[0..(my_hash.length - 2)]
    my_hash << "]"

    render json: my_hash
  end
end
