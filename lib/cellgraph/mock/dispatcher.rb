module Cellgraph
  module Mock
    class Dispatcher
      def initialize
        @listeners = {}
      end

      def register_listener(name, listener_instance)
        @listeners[name.to_sym] = Listener.new
      end

      def [](name)
        @listeners[name.to_sym]
      end

      def invoked?(name, callback_name)
        invoked_times(name, callback_name) > 0
      end

      def invoked_times(name, callback_name)
        @listeners[name.to_sym].invoked_times(callback_name)
      end

      def reset!
        @listeners.each_value(&:reset!)
      end
    end
  end
end
