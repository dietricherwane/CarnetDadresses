class ForumPostsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!

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
end
