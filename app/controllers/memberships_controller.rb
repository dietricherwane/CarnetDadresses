class MembershipsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def api_show
    membership = Membership.find_by_id(params[:id]).as_json
    my_hash = api_render_object(membership, {}, ["published", "updated_at", "created_at", "id"])

    render json: my_hash
  end
end
