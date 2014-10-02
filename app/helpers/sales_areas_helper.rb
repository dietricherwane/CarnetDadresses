module SalesAreasHelper
  def sales_area_messages!
    return "" if @sales_area.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end
end
