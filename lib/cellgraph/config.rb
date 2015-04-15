require 'active_support/configurable'

module Cellgraph
  class Configuration
    include ActiveSupport::Configurable

    # Maps models to actor listeners OR we can have one actor registered
    config_accessor :mappings do
      {}
    end

    config_accessor :cellgraph_field do
      :parentable
    end

    config_accessor :log_path do
      'cellgraph.log'
    end

    config_accessor :logger do
      if defined?(Rails) && !Rails.logger.nil?
        Rails.logger
      else
        Logger.new(log_path)
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
