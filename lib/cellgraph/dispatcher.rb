module Cellgraph
# Basic dispatcher, subclass to customize implementation
  class Dispatcher
    include Singleton

    attr_accessor :servitor

    def initialize
      @servitor = []
    end

    def self.servitor
      instance.servitor
    end

    # Allows config options to be read like a hash
    #
    # @param [Symbol] option Key for a given attribute
    def self.[](option)
      instance.servitor[option.to_sym]
    end
  end
end