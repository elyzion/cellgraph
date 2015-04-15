require "rubygems"
require "bundler/setup"
require "simplecov"
require "with_model"
require 'celluloid/test'
require "cellgraph"

SimpleCov.start do
  add_filter "spec"
  add_filter "vendor"
end

$: << File.join(File.dirname(__FILE__), "..", "lib")


config_json = File.open(File.join("spec", "config", "database.json")).read
ActiveRecord::Base.establish_connection(JSON.parse(config_json, :symbolize_keys => true))

logfile = File.open(File.expand_path("../../log/test.log", __FILE__), 'a')
logfile.sync = true

Celluloid.logger = Logger.new(logfile)
Celluloid.shutdown_timeout = 1
$CELLULOID_DEBUG = true


RSpec.configure do |config|
  config.extend WithModel

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  config.before(:each) do
    Cellgraph.reset
  end

  Kernel.srand config.seed
end
