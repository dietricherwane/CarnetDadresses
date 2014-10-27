class MaritalStatusesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  def api_show
    marital_status = MaritalStatus.find_by_id(params[:id]).as_json

    if marital_status
      marital_status = "[" << marital_status.except!(*["published", "updated_at", "created_at", "id"]).to_json << "]"
    else
      marital_status = []
    end

    render json: marital_status
  end
end