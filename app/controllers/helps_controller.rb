class HelpsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @help = Help.new
    @helps = Help.all
  end
  
  def create
    @help = Help.first
    @helps = Help.all
    type = params[:help_type]
    
    if @help.blank?
      Help.create(:"#{type}_content" => params[:content], :"#{type}_updated_at" => DateTime.now, :"#{type}_user_id" => current_user.id)
    else
      @help.update_attributes(:"#{type}_content" => params[:content], :"#{type}_updated_at" => DateTime.now, :"#{type}_user_id" => current_user.id)
    end
    
    @help = Help.new
    flash.now[:success] = "L'Aide a été correctement mise à jour."
    
    render :index
  end
end
