module Cellgraph
  class EventInterface
    # Invoked after payload is saved.
    # Return any non truthy value to cause a rollback.
    def saved(payload)
      true
    end

    # Invoked after a payload related to name and id is saves.
    # Return any non truthy value to cause a rollback.
    def addressed_saved(name, id, payload)
      true
    end

    # Invoked after deletion of payload.
    # Return any non truthy value to cause a rollback.
    def deleted(payload)
      true
    end

    # Invoked after deletion of payload.
    # Return any non truthy value to cause a rollback.
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