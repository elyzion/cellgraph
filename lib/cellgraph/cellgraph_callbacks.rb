module Cellgraph
  class CellgraphCallbacks
    # Signals all relevant parties with created instance.
    # Raises an exception that reverts the transaction if there
    # is an create failure in a relevant party.
    def self.after_create(instance)
      after_save(:created, instance)
    end

    # Signals all relevant parties with updated instance.
    # Raises an exception that reverts the transaction if there
    # is an update failure in a relevant party.
    def self.after_update(instance)
      after_save(:updated, instance)
    end

    # Signals all relevant parties with created or updated instance.
    # Raises an exception that reverts the transaction if there
    # is an update failure in a relevant party.
    def self.after_save(method, instance)
      # TODO refactor shared code
      name = ActiveModel::Naming.singular(instance)
      if Cellgraph.configuration.mappings.key?(name.to_sym)
        return false unless Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Cellgraph.dispatcher[listener.to_sym]
        }.each { |listener|
          Cellgraph.dispatcher[listener.to_sym].send(method, instance)
        }
      end
      unless instance.send("has_null_cellgraph_field")
        parent = instance.send(instance.cellgraph_field_type).constantize.model_name.singular
        unless Cellgraph.dispatcher[parent.to_sym]
          fail "Missing parent (#{instance.cellgraph_field_id}, #{instance.cellgraph_field_type}) for #{parent}, please add an entry for this parent to you dispatcher."
        end
        addressed_method = "addressed_#{method}"
        return Cellgraph.dispatcher[parent.to_sym].send(addressed_method, instance.send(instance.cellgraph_field_type), instance.send(instance.cellgraph_field_id), instance)
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
        Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Cellgraph.dispatcher[listener.to_sym]
        }.each { |listener|
          unless Cellgraph.dispatcher[listener.to_sym].deleted(instance)
            fail "Deletion listener failed"
          end
        }
      end

      unless instance.send("has_null_cellgraph_field")
        parent = instance.send(instance.cellgraph_field_type).constantize.model_name.singular
        fail "Missing parent (#{instance.cellgraph_field_id}, #{instance.cellgraph_field_type}) for #{parent}" unless Cellgraph.dispatcher[parent.to_sym]
        return Cellgraph.dispatcher[parent.to_sym].addressed_deleted(instance.send(instance.cellgraph_field_type), instance.send(instance.cellgraph_field_id), instance)
      end
    end
  end
end
