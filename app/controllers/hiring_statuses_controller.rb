class HiringStatusesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def api_show
    hiring_status = HiringStatus.find_by_id(params[:id]).as_json

    if hiring_status
      hiring_status = "[" << hiring_status.except!(*["published", "updated_at", "created_at", "id"]).to_json << "]"
    else
      hiring_status = []
    end

    render json: hiring_status
  end

end
