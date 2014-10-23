module AdressBookHobbiesHelper
  def adress_book_hobby_messages!
    return "" if @adress_book_hobby.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end
end
