module FormationsHelper

  def formation_messages!
    return "" if @formation.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end

end
