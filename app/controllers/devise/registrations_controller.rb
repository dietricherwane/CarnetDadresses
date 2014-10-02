class Devise::RegistrationsController < DeviseController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_scope!
  
  layout :layout_used
  
  # GET /resource/sign_up
  def new
    @profiles = Profile.where(published: [nil, true], shortcut: "ADM")
    @social_statuses = SocialStatus.where(published: [nil, true])
    @users = User.all.page(params[:page]).per(10)
    
    build_resource({})
    respond_with self.resource
  end

  # POST /resource
  def create
    @profiles = Profile.where(published: [nil, true], shortcut: "ADM")
    @social_statuses = SocialStatus.where(published: [nil, true])
    @users = User.all.page(params[:page]).per(10)
    
    build_resource(params[:user])
    #build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        #flash[:notice] = "Le compte de l'utilisateur a été créé. Il va recevoir un email contenant un lien sur lequel il devra cliquer pour activer son compte."
        redirect_to admin_dashboard_path
        #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  # Edit an admin profile
  def edit_admin
    @user = User.find_by_id(params[:id])
    @users = User.all.page(params[:page]).per(10)
    
    unless @user
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end  
  end
  
  # Update an admin profile
  def update_admin
    @user = User.find_by_id(params[:id])
    if @user.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else      
      @user.update_attributes(params[:user])
      @user.errors.full_messages.blank? ? flash.now[:success] = "Le profil a été mis à jour." : false
      @users = User.all.page(params[:page]).per(10)    
      render :edit_admin, id: @user.id
    end     
  end
  
  # Search an admin
  def search_admin
    @profiles = Profile.where(published: [nil, true], shortcut: "ADM")
    @social_statuses = SocialStatus.where(published: [nil, true])
    @user = User.new
    
    @fields = ["firstname", "lastname", "phone_number", "mobile_number", "email"]
    @terms = params[:terms].strip.split
    
    # executes a search function in application_controller to return results
    search_function

    @users = User.where(@sql)
    flash.now[:success] = "#{@users.count} résultat#{@users.count > 1 ? "s" : ""} de recherche."
    @users = @users.page(params[:page]).per(10)
  end
  
  def disable_user
    enable_disable_user("désactiver", "désactivé", false)
  end
  
  def enable_user
    enable_disable_user("activer", "activé", true)
  end
  
  def enable_disable_user(message1, message2, status)
    @user = User.find_by_id(params[:id])
    if @user.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      if @user.id == current_user.id
        flash.now[:alert] = "Vous ne pouvez pas #{message1} votre propre compte."
      else      
        @user.update_attributes(published: status)
        flash.now[:success] = "Le compte a été #{message2}."          
      end
      @profiles = Profile.where(published: [nil, true], shortcut: "ADM")
      @social_statuses = SocialStatus.where(published: [nil, true])
      @users = User.all.page(params[:page]).per(10)
      @user = User.new
      
      render :new
    end   
  end
  
  def format_term(term)
    return term.split.to_s.sub("[", "(").sub("]", ")")
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.for(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.for(:account_update)
  end
end
