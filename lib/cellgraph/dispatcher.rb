module Cellgraph
  # Basic dispatcher, subclass to customize implementation
  class Dispatcher
    include Singleton

    attr_accessor :servitor

    def initialize
      @servitor = {}
    end

    def register_listener(name, listener_instance)
      @servitor[name.to_sym] = listener_instance
    end

    def [](option)
      @servitor[option.to_sym]
    end
  end
end
