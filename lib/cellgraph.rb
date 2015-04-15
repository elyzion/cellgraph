require 'active_record' unless defined? ActiveRecord
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
    @dispatcher ||= Cellgraph::Dispatcher.instance
  end

  # Set dispatcher.
  def self.dispatcher=(value)
    @dispatcher = value
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
    @dispatcher = Cellgraph::Mock::Dispatcher.new
  end
end
