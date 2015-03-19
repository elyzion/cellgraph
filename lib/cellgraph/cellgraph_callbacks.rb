module Cellgraph
  class CellgraphCallbacks
    # Signals all relevant parties with updated instance.
    # Raises an exception that reverts the transaction if there
    # is an update failure in a relevant party.
    def self.after_save(instance)
      # TODO refactor shared code
      name = ActiveModel::Naming.singular(instance)
      if Cellgraph.configuration.mappings.key?(name.to_sym)
        fail "Only one to one mapping allowed currently" if Cellgraph.configuration.mappings[name.to_sym].count > 1
        return Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Celluloid::Actor[listener.to_sym]
        }.each { |listener|
          unless Celluloid::Actor[listener.to_sym].future.saved(self)
            fail "Updated listener failed."
          end
        }
      end
      if !instance.send("has_null_cellgraph_field")
        parent = instance.send(instance.cellgraph_field_type).constantize.model_name.singular
        Celluloid::Actor[parent.to_sym].future.addressed_saved(instance.cellgraph_field_id, instance.cellgraph_field_type, self)
      end
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

      name = ActiveModel::Naming.singular(instance)
      if Cellgraph.configuration.mappings.key?(name.to_sym)
        fail "Only one to one mapping allowed currently" if Cellgraph.configuration.mappings[name.to_sym].count > 1
        return Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Celluloid::Actor[listener.to_sym]
        }.each { |listener|
          Celluloid::Actor[listener.to_sym].future.deleted(self)
        }
      end

      if !instance.send("has_null_cellgraph_field")
        parent = instance.send(instance.cellgraph_field_type).constantize.model_name.singular
        Celluloid::Actor[parent.to_sym].future.addressed_deleted(instance.cellgraph_field_id, instance.cellgraph_field_type, self)
      end
    end
  end
end