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
        return false unless Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Celluloid::Actor[listener.to_sym]
        }.each { |listener|
          Celluloid::Actor[listener.to_sym].saved(instance)
        }
      end
      unless instance.send("has_null_cellgraph_field")
        parent = instance.send(instance.cellgraph_field_type).constantize.model_name.singular
        fail "Missing parent (#{instance.cellgraph_field_id}, #{instance.cellgraph_field_type}) for #{parent}" unless Celluloid::Actor[parent.to_sym]
        return Celluloid::Actor[parent.to_sym].addressed_saved(instance.send(instance.cellgraph_field_id), instance.send(instance.cellgraph_field_type), instance)
      end
      true
    end

    # Checks that destroy method execution is allowed.
    def self.before_destroy(instance)
      instance.deletable?
    end

    # If the instance was destroyed, signal all interested parties that it was destroyed.
    # If an interested party fails, we return an exception and undo the transaction.
    def self.after_destroy(instance)
      # TODO refactor shared code
      name = ActiveModel::Naming.singular(instance)
      if Cellgraph.configuration.mappings.key?(name.to_sym)
        fail "Only one to one mapping allowed currently" if Cellgraph.configuration.mappings[name.to_sym].count > 1
        Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Celluloid::Actor[listener.to_sym]
        }.each { |listener|
          unless Celluloid::Actor[listener.to_sym].deleted(instance)
            fail "Deletion listener failed"
          end
        }
      end

      unless instance.send("has_null_cellgraph_field")
        parent = instance.send(instance.cellgraph_field_type).constantize.model_name.singular
        fail "Missing parent (#{instance.cellgraph_field_id}, #{instance.cellgraph_field_type}) for #{parent}" unless Celluloid::Actor[parent.to_sym]
        return Celluloid::Actor[parent.to_sym].addressed_deleted(instance.send(instance.cellgraph_field_id), instance.send(instance.cellgraph_field_type), instance)
      end
    end
  end
end