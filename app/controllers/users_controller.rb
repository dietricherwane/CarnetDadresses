class UsersController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!

  layout :layout_used

  def index_dashboard
    @users = User.where(profile_id: Profile.user_id).page(params[:page]).per(10)
  end

  def disable_user
    enable_disable_user("désactivé", false)
  end

  def enable_user
    enable_disable_user("activé", true)
  end

  def enable_disable_user(message, status)
    @user = User.find_by_id(params[:id])
    if @user.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      if @user.id == current_user.id
        flash.now[:alert] = "Vous ne pouvez pas modifier votre propre compte."
      else
        @user.update_attributes(published: status)
        flash.now[:success] = "Le compte a été #{message}."
      end
      @users = User.where(profile_id: Profile.user_id).page(params[:page]).per(10)

      render :index_dashboard
    end
  end

  def registrations
    @user = User.find_by_id(params[:user_id])
    if @user
      @registrations = @user.registrations.page(params[:page]).per(10)
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
end
