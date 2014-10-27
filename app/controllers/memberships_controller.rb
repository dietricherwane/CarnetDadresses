class MembershipsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def api_show
    membership = Membership.find_by_id(params[:id]).as_json

    if membership
      membership = "[" << membership.except!(*["published", "updated_at", "created_at", "id"]).to_json << "]"
    else
      membership = []
    end

    render json: membership
  end
end
