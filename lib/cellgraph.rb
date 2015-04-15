require 'active_record' unless defined? ActiveRecord
require 'cellgraph/dispatcher'
require 'cellgraph/config'
require 'cellgraph/event_interface'
require 'cellgraph/cellgraph_callbacks'
require 'cellgraph/acts_as_cellgraph'

module Cellgraph
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
end
