module ForumThemesHelper
  def forum_theme_messages!
    return "" if @forum_theme.errors.empty?

    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end

    messages!
  end
end
