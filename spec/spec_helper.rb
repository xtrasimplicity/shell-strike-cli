require 'rubygems'
require 'rspec'
require 'simplecov'

SimpleCov.start

require File.expand_path('../../lib/shell_strike', __FILE__)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

# Require support files
Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))).each { |rb| require rb }