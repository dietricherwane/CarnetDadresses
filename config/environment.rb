# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
CarnetDadresse::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag.match(/class="ckeditor"/).blank?
    html = %(#{html_tag.gsub(/class=".*?"/, "class='form-control error'")}).html_safe
  else
    html = html_tag.html_safe
  end
  html
end
