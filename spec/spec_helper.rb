
require 'rubygems'
require 'rspec'

require File.expand_path('../../lib/ShellStrike', __FILE__)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

# Require concerns
Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), 'concerns', '**', '*.rb'))).each { |rb| require rb }