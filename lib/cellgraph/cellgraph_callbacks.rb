module Cellgraph
  class CellgraphCallbacks
    # Signals all relevant parties with updated instance.
    # Raises an exception that reverts the transaction if there
    # is an update failure in a relevant party.
    def self.after_update(instance)
      # update parent if parent
      # signal listeners
      # Todo actor[].update
      p "update callback"
    end

    # Checks that destroy method execution is allowed.
    def self.before_destroy(instance)
      if instance.deletable?
        return true
      end
      false
    end

    # If the instance was destroyed, signal all interested parties that it was destroyed.
    # If an interested party fails, we return an exception and undo the transaction.
    def self.after_destroy(instance)

      # todo actor[].delete
      p "after_destroy callback"
    end
  end
end