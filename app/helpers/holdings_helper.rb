module HoldingsHelper

  def holding_messages!
    return "" if @holding.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end

end
