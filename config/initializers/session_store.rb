# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tcorps_session',
  :secret      => '0ef3db7bb5a3e6c1a8083a895abe7f3fa824f63997409939b4be6e4d99e1dc3c2dc143c3a63c4290d6218b7ab17ab6c728582d62848c6f9f11bffa94739fdda7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
