module Cellgraph
  # Defines the event interface used by Cellgraph actors
  # Addressed version are invoked by children on their parents.
  class EventInterface
    # Invoked after payload is created.
    # Return any non truthy value to cause a rollback.
    def created(payload)
      true
    end

    # Invoked after a payload related to name and id is saves.
    # Return any non truthy value to cause a rollback.
    def addressed_created(name, id, payload)
      true
    end

    # Invoked after payload is updated.
    # Return any non truthy value to cause a rollback.
    def updated(payload)
      true
    end

    # Invoked after a payload related to name and id is saves.
    # Return any non truthy value to cause a rollback.
    def addressed_updated(name, id, payload)
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
