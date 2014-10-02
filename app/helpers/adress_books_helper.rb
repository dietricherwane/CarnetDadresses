module AdressBooksHelper

  def address_book_messages!
    return "" if @adress_book.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end
  
end
