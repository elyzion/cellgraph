module Cellgraph
  class EventInterface
    def saved(payload)
      true
    end

    def addressed_saved(name, id, payload)
      true
    end

    # Delete event
    def deleted(payload)
      true
    end

    # Delete event
    def addressed_deleted(name, id, payload)
      true
    end

    # Returns true if this listener does not protest the deletion of payload.
    def deletable?(payload)
      true
    end

    # Returns true if the entity specified by name and id at this listener does not protest the deletion of payload.
    def addressed_deletable?(name, id, payload)
      true
    end
  end
end