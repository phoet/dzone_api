# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_dzone_api_session',
  :secret => '9ae78457d163ff5f5ac1ca15320c1c00717c84c2a536ed99cd47f95831a8cf39cb48d49cede5af042f7a41ad5f7831a76b585b45259ee01325e61dfd3062e8a7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
