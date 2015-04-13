require 'active_support/configurable'

module Cellgraph

  class << self
    attr_writer :configuration
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
  def self.configure(&block)
    yield @configuration ||= Cellgraph::Configuration.new
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable

    config_accessor :dispatcher do
      Cellgraph::Dispatcher.instance
    end
    # Maps models to actor listeners OR we can have one actor registered
    config_accessor :mappings do
      {}
    end
    config_accessor :cellgraph_field do
      :parentable
    end
    config_accessor :log_path do
      "cellgraph.log"
    end
    config_accessor :logger do
      if defined?(Rails) && !Rails.logger.nil?
        Rails.logger
      else
        Logger.new(Cellgraph.configuration.log_path)
      end
    end

    # Allows config options to be read like a hash
    #
    # @param [Symbol] option Key for a given attribute
    def [](option)
      __send__(option)
    end
  end
end
