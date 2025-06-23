Rails Project Setup with PostgreSQL and Devise
1. Create a New Rails Project
Ensure you have Ruby, Rails, and PostgreSQL installed. Then, run the following commands to create a new Rails project with PostgreSQL as the database.
# Install Rails if not already installed
gem install rails

# Create a new Rails project with PostgreSQL
rails new hospital_portal -d postgresql

# Navigate to the project directory
cd hospital_portal

2. Set Up PostgreSQL User
Create a new PostgreSQL user and database for the application. Replace hospital_user and your_password with your desired username and password.
# Access PostgreSQL command line
psql -U postgres

# Create a new PostgreSQL user
CREATE ROLE hospital_user WITH LOGIN PASSWORD 'your_password';

# Grant privileges to the user
ALTER ROLE hospital_user CREATEDB;

# Exit PostgreSQL
\q

Update the config/database.yml file to use the new PostgreSQL user.
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: hospital_user
  password: your_password
  host: localhost

development:
  <<: *default
  database: hospital_portal_development

test:
  <<: *default
  database: hospital_portal_test

production:
  <<: *default
  database: hospital_portal_production
  username: hospital_user
  password: <%= ENV['HOSPITAL_PORTAL_DATABASE_PASSWORD'] %>

Create the database:
# Create the database
rails db:create

3. Set Up Devise for Authentication
Add Devise to the project and configure it for user authentication.
Add Devise Gem
Edit the Gemfile to include Devise:
gem 'devise'

Install the gem:
bundle install

Install Devise
Run the Devise installer to set up configuration files:
rails generate devise:install

Configure Devise
Add the following to config/environments/development.rb to set up mailer for development:
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

Generate User Model
Create a User model with Devise:
rails generate devise User

Migrate the database to create the users table:
rails db:migrate

Create Login Page
Update app/views/layouts/application.html.erb to include navigation links for login/logout:
<!DOCTYPE html>
<html>
<head>
  <title>HospitalPortal</title>
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
  <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
</head>
<body>
  <nav>
    <% if user_signed_in? %>
      <%= link_to "Logout", destroy_user_session_path, method: :delete %>
    <% else %>
      <%= link_to "Login", new_user_session_path %>
      <%= link_to "Sign Up", new_user_registration_path %>
    <% end %>
  </nav>
  <%= yield %>
</body>
</html>

Generate Devise views to customize the login page:
rails generate devise:views

Customize the login page by editing app/views/devise/sessions/new.html.erb:
<h2>Log in</h2>

<%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
  <div class="field">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
  </div>

  <div class="field">
    <%= f.label :password %><br />
    <%= f.password_field :password, autocomplete: "current-password" %>
  </div>

  <% if devise_mapping.rememberable? %>
    <div class="field">
      <%= f.check_box :remember_me %>
      <%= f.label :remember_me %>
    </div>
  <% end %>

  <div class="actions">
    <%= f.submit "Log in" %>
  </div>
<% end %>

<%= render "devise/shared/links" %>

Test the Setup
Start the Rails server:
rails server

Visit http://localhost:3000/users/sign_in to see the login page. You can sign up at http://localhost:3000/users/sign_up to create a new user.