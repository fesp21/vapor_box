# Load the rails application
require File.expand_path('../application', __FILE__)


ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 25, # ports 587 and 2525 are also supported with STARTTLS
    :enable_starttls_auto => true, # detects and uses STARTTLS
    :user_name => "admin@getvaporbox.com",
    :password  => "nF46u3gi1S2", # SMTP password is any valid API key
    :authentication => 'login', # Mandrill supports 'plain' or 'login'
    :domain => 'getvaporbox.com', # your domain to identify your server when connecting
  }

# Initialize the rails application
Myapp::Application.initialize!


