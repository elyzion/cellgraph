module Cellgraph
  module Mock
    class Listener
      def initialize
        @invoked_times = Hash.new(0)
      end

      def created(payload)
        @invoked_times[__method__] += 1
        true
      end

      def addressed_created(name, id, payload)
        @invoked_times[__method__] += 1
        true
      end

      def updated(payload)
        @invoked_times[__method__] += 1
        true
      end

      def addressed_updated(name, id, payload)
        @invoked_times[__method__] += 1
        true
      end

      def deleted(payload)
        @invoked_times[__method__] += 1
        true
      end

      def addressed_deleted(name, id, payload)
        @invoked_times[__method__] += 1
        true
      end

      def deletable?(payload)
        @invoked_times[__method__] += 1
        true
      end

      def addressed_deletable?(name, id, payload)
        @invoked_times[__method__] += 1
        true
      end

      def invoked_times(callback_name)
        @invoked_times[callback_name.to_sym]
      end

      def reset!
        @invoked_times = Hash.new(0)
      end
    end
  end
end
