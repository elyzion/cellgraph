require 'active_record' unless defined? ActiveRecord
require 'cellgraph/dependents_present_error'
require 'cellgraph/parent_present_error'
require 'cellgraph/dispatcher'
require 'cellgraph/config'
require 'cellgraph/event_interface'
require 'cellgraph/cellgraph_callbacks'
require 'cellgraph/acts_as_cellgraph'
require 'cellgraph/mock/dispatcher'
require 'cellgraph/mock/listener'

module Cellgraph
  # Get dispatcher.
  def self.dispatcher
    configuration.dispatcher
  end

  # Return the current configuration or a new one.
  def self.configuration
    @configuration ||= Cellgraph::Configuration.new
  end

  # Resets the configuration
  def self.reset
    @configuration = Cellgraph::Configuration.new
  end

  # Configures global settings for CellGraph
  #   CellGraph.configure do |config|
  #     config.cellgraph_field = :my_field
  #   end
  def self.configure
    yield(configuration)
  end

  def self.mock!
    configuration.dispatcher = Cellgraph::Mock::Dispatcher.new
  end
end
