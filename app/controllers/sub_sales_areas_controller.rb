class SubSalesAreasController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def api_show
    sub_sales_area = SubSalesArea.find_by_id(params[:id])
    sales_areas = sub_sales_area.sales_area rescue nil
    sub_sales_area = sub_sales_area.as_json

    my_hash = api_render_object(sub_sales_area, {sales_area_name: sales_areas.name}, ["published", "updated_at", "created_at", "id", "sales_area_id"])

    render json: my_hash
  end
end
