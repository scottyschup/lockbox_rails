source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.beta3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '>= 4.0.0.rc.3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.1', require: false

gem 'devise', '~> 4.6.2'
gem 'font-awesome-rails'
gem 'bootstrap', '~> 4.3.1'

gem 'money-rails', '~>1.12'

gem 'verbalize', '~> 2.2'

gem 'cocoon'

# TODO -- before we go live, should move this back to test/dev bundle
# For test data generation
gem 'factory_bot_rails', '~> 5.0', '>= 5.0.1'
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'

  # RSpec & testing gems!

  # Apparently rspec is not yet ready for rails 6 :(
  # gem 'rspec-rails', '~> 3.8'
  gem 'rspec-rails', github: 'rspec/rspec-rails', branch: '4-0-dev'
  gem 'rspec', github: 'rspec/rspec', branch: 'master'
  gem 'rspec-core', github: 'rspec/rspec-core', branch: 'master'
  gem 'rspec-mocks', github: 'rspec/rspec-mocks', branch: 'master'
  gem 'rspec-expectations', github: 'rspec/rspec-expectations', branch: 'master'
  gem 'rspec-support', github: 'rspec/rspec-support', branch: 'master'
  gem 'rails-controller-testing'

  gem 'shoulda-matchers', '~> 4.0', '>= 4.0.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing
  gem 'capybara', '>= 2.15'
  # gem 'selenium-webdriver' # TODO: SSS remove if not needed
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers', '~> 4.0'

  # This is used in CI
  gem 'rspec_junit_formatter', '~> 0.4.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
