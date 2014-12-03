class HelpsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show_website_help, :api_show_wallet_help]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

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

  def api_show_website_help
    render json: "{"'"data"'":[" << {message: (Help.first.website_content rescue "")}.to_json.to_s << "]}"
  end

  def api_show_wallet_help
    render json: "{"'"data"'":[" << {message: (Help.first.wallet_content rescue "")}.to_json.to_s << "]}"
  end
end
