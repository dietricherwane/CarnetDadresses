module NewsFeedsHelper
  def news_feed_messages!
    return "" if @news_feed.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end
end
