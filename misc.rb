ActiveRecord::Base.connection.reset_pk_sequence!("profiles")

#Customizing whysihat to work with ruby2.0.0 and rails4.0.7
#https://github.com/80beans/wysihat-engine/wiki/installation

### Gemfile
gem 'wysihat-engine'

### Console
bundle install

### /home/erwan/.rvm/gems/ruby-2.0.0-p195@rails4.0.7/gems/wysihat-engine-0.1.13/generators/wysihat/wysihat
--Comment the existing method
protected
  def next_migration_number(dirname) #:nodoc:
    "%.3d" % (current_migration_number(dirname) + 1)
  end

### /home/erwan/.rvm/gems/ruby-2.0.0-p195@rails4.0.7/gems/wysihat-engine-0.1.13/generators/wysihat/wysihat_generator.rb
--Comment the existing line
#m.system 'script/plugin install git://github.com/markcatley/responds_to_parent.git'
m.system 'gem install git://github.com/markcatley/responds_to_parent.git'

### /home/erwan/.rvm/gems/ruby-2.0.0-p195@rails4.0.7/gems/wysihat-engine-0.1.13/lib/generators/wysihat_generator.rb
--Comment the existing line
#plugin 'responds_to_parent', :git => 'git://github.com/markcatley/responds_to_parent.git'
gem 'responds_to_parent'#, :git => 'git://github.com/markcatley/responds_to_parent.git'

# Console
rails generate wysihat
bundle install
rake db:migrate

--Move the css and js files from public folder to assets  folder

--Include the previously moved files in the templates

--After installing, you can use the wysihat_editor form field in your forms, like this:

<% form_for(@page) do |f| %>
  <%= f.error_messages %>
  <p>
    <%= f.label :content %><br />
    <%= f.wysihat_editor :content %>
  </p>
  <p>
    <%= f.submit 'Create' %>
  </p>
<% end %>
