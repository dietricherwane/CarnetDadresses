module DeviseHelper
  # A simple way to show error messages for the current devise resource. If you need
  # to customize this method, you can either overwrite it in your application helpers or
  # copy the views to your application.
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    
    # Get current layout and name notification class accordingly
    controller.send(:_layout) == "sessions" ? @notification_class = "session_notification" : @notification_class = "notification"
    
    html = <<-HTML
    <script type = "text/javascript">
      $(document).on('ready page:load', function(){  
        $("#button-close").click(function() {
          $(".#{@notification_class}").hide();
        });
      });
    </script>  
    <div class="#{@notification_class} warning fade in">
      <p>
        <div id style = "float:right;">
          <a style = "cursor: pointer; text-decoration: none;" id = "button-close">×</a>
        </div>     
        <span>
          #{messages}
        </span>
      </p>
    </div>     
    HTML

    html.html_safe
  end
end
