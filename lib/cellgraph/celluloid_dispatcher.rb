module Cellgraph
# Basic dispatcher, subclass to customize implementation
  class CelluloidDispatcher < Cellgraph::Dispatcher

    # Allows config options to be read like a hash
    #s
    # @param [Symbol] option Key for a given attribute
    def self.[](option)
      Celluloid::Actor[option.to_sym]
    end
  end
end