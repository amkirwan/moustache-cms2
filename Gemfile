source 'http://rubygems.org'

gem "rails", "~> 4.2"   

gem "sass-rails"
gem "coffee-rails"
gem "uglifier"

gem "coffee-rails"

gem "jquery-rails"
gem "haml-rails"

# mongoid
gem "mongoid", "~> 5.1"
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

# authorization
gem "devise" 
gem "cancancan"  # must come after mongoid in Gemfile

# use until move to strong params
gem 'protected_attributes'

gem "mustache", ">= 0.99"
gem "RedCloth", "~> 4.2"
gem "redcarpet", "~> 2.0"
gem "mime-types"
gem "kaminari"
# gem "rakismet" #uncomment to spam filter comments on articles

gem "nokogiri", "~> 1.5"
# gem "unicorn"

# gem "capistrano" #uncomment to capify

group :development, :test do
  gem "rspec-rails"
  # gem "cucumber-rails", "~> 1.3", :require => false
  gem "capybara"
  # gem "selenium-webdriver", "~> 2.34.0"
  gem "launchy"
  gem "database_cleaner"
  gem "factory_girl_rails", "~> 3.1"
  gem "mongoid-rspec"
  gem "hpricot"
  gem "syntax"   
  gem "relish"
  # gem "guard"
  # gem 'rb-fsevent', '~> 0.9.1'
  # gem "guard-cucumber", :git => "git://github.com/netzpirat/guard-cucumber.git"
  # gem "guard-rspec"
  # gem "guard-spork"
  # gem "guard-pow"
end
