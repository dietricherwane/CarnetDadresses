class RegistrationsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!

  layout :layout_used

  def admin_create
    user = User.find_by_id(params[:user_id])
    last_registration = user.last_registration
    last_registration ? (expires_at = last_registration.expires_at + 1.year) : (expires_at = Date.today + 1.year)
    if user
      user.registrations.create(created_by: current_user.id, transaction_id: DateTime.now.to_i, expires_at: expires_at)
      flash[:success] = "L'enregistrement a été effectué."
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

    redirect_to user_registrations_path(user.id)
  end
end
