module Cellgraph
  module ActsAsCellgraph
    extend ActiveSupport::Concern

    included do
      after_create CellgraphCallbacks
      after_update CellgraphCallbacks
      before_destroy CellgraphCallbacks
      after_destroy CellgraphCallbacks
    end

    module ClassMethods
      def acts_as_cellgraph(options = {})
        unless options.is_a?(Symbol) && options === :parentless
          cattr_accessor :cellgraph_field
          cattr_accessor :cellgraph_field_type
          cattr_accessor :cellgraph_field_id

          self.cellgraph_field = (options[:cellgraph_field] || Cellgraph.configuration[:cellgraph_field]).to_s
          self.cellgraph_field_type = "#{self.cellgraph_field}_type"
          self.cellgraph_field_id = "#{ self.cellgraph_field}_id"
        end
      end
    end

    # Return true if this record is deletable.
    # A deletable record is defined as a record
    # that:
    # 1) Has no cellgraph_field, ie, no parent.
    # 2) and/or has no listener that object to the deletion.
    # If the record is not deletable, it returns an exception object with the details.
    def deletable?
      has_null_cellgraph_field! && query_deletion_listeners
    end

    # Same as deletable, but returns reasons for denial.
    # TODO Detailed reasons for denial.
    def deletable;
      deletable?
    end

    alias :destroyable? :deletable?
    alias :destroyable :deletable?
    alias :destroyable :deletable

    private

    # Check if the id column is present and not null
    def has_null_cellgraph_field
      begin
        return has_null_cellgraph_field!
      rescue Exception => e
        return false
      end
    end

    # Check if the id column is present and not null
    def has_null_cellgraph_field!
      if self.class.send("method_defined?", "cellgraph_field_id") && self.class.send("method_defined?", self.cellgraph_field_id) && !self.send(self.cellgraph_field_id).nil?
        raise ParentPresentError.new(self.send(self.cellgraph_field_type))
      end
      true
    end

    # Queries registered listeners for this model.
    # Returns false if any listener objects to deletion.
    def query_deletion_listeners
      name = ActiveModel::Naming.singular(self)
      if Cellgraph.configuration.mappings.key?(name.to_sym)
        objectors = []
        Cellgraph.configuration.mappings[name.to_sym].select { |listener|
          Cellgraph.dispatcher[listener.to_sym]
        }.map { |listener|
          value = Cellgraph.dispatcher[listener.to_sym].deletable?(self)
          if !value
            objectors.push listener.to_sym
          end
          value
        }

        if objectors.empty?
          return true
        end
        raise DependentsPresentError.new objectors
      end
      Cellgraph.configuration.logger.warn "No listener(s) registered for #{name}"
      true
    end
  end
end

ActiveRecord::Base.send :include, Cellgraph::ActsAsCellgraph
