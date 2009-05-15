ActionMailer::Base.smtp_settings = {
  :address => 'smtp.sunlightlabs.com',
  :port => 25,
  :user_name => 'smtpclient',
  :password => 'mryogato',
  :authentication => :plain,
  :domain => 'sunlightlabs.com'
}