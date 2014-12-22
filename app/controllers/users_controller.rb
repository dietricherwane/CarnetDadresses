class UsersController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_get_authentication_token, :api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

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

  def api_get_authentication_token
    my_user = User.find_by_email(params[:email])
    if my_user && my_user.sign_in_count == 0
      user = User.authenticate(params[:email], 'carnetdadresses')
    else
      user = User.authenticate(params[:email], params[:password])
    end

    if user
      #if user.confirmation_token.blank?
        message = "{"'"data"'":[" << {token: user.authentication_token, firstname: user.firstname, lastname: user.lastname}.to_json.to_s << "]}"
      #else
        #message = "{"'"data"'":[" << {errors: "Veuillez activer votre compte en cliquant sur le lien de confirmation reçu par mail."}.to_json.to_s << "]}"
      #end
    else
      message = "{"'"data"'":[" << {errors: "Veuillez vérifier la combinaison login/mot de passe."}.to_json.to_s << "]}"
    end

    render json: message
  end

  def api_show
    user = User.find_by_authentication_token(params[:token])

    if user
      message = "{"'"data"'":[" << user.as_json.merge!(sign_in_count: user.sign_in_count).except(*api_fields_to_except).to_json << "]}"
    else
      message = "{"'"data"'":[" << {errors: "Le token n'est pas valide."}.to_json.to_s << "]}"
    end

    render json: message
  end

  def api_fields_to_except
    return ["id", "profile_id", "updated_at", "created_by", "validated_by", "validated_at", "unpublished_by", "unpublished_at"]
  end

end
