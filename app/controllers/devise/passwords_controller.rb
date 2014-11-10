class Devise::PasswordsController < DeviseController
  prepend_before_filter :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_filter :assert_reset_token_passed, :only => :edit

  layout :layout_used

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def api_send_reset_password_instructions
    user = User.find_by_authentication_token(params[:token])

    if user
      user.send_reset_password_instructions
      message = "[" << {message: "Un email de réinitialisation de mot de passe vient d'être envoyé à l'utilisateur."}.to_json.to_s << "]"
    else
      message = "[" << {errors: "Le token n'est pas valide."}.to_json.to_s << "]"
    end

    render json: message
  end

  def api_reset_password
    if params[:password] != params[:password_confirmation]
      message = "[" << {errors: "Le mot de passe et sa confirmation ne sont pas identiques."}.to_json.to_s << "]"
    else
      user = User.reset_password_by_token(reset_password_token: params[:reset_token], password: params[:password], confirmation: params[:password_confirmation])

      if user.errors.empty?
        message = "[" << {message: "Le mot de passe a été mis à jour."}.to_json.to_s << "]"
      else
        message = "[" << {errors: user.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join}.to_json.to_s << "]"
      end
    end

    render json: message
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end

  protected
    def after_resetting_password_path_for(resource)
      after_sign_in_path_for(resource)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_session_path(resource_name) if is_navigational_format?
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_session_path(resource_name)
      end
    end

    # Check if proper Lockable module methods are present & unlock strategy
    # allows to unlock resource on password reset
    def unlockable?(resource)
      resource.respond_to?(:unlock_access!) &&
        resource.respond_to?(:unlock_strategy_enabled?) &&
        resource.unlock_strategy_enabled?(:email)
    end
end
