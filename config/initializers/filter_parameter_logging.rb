# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  # Regex string matching;
  # will filter any param with the following substrings
  :password, # :password_confirmation, :current_password
  :email,
  :name, # :name_or_alias
  :text
]
