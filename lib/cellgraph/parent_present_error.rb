module Cellgraph
  class ParentPresentError < StandardError
    attr_reader :parent_type
    attr_reader :parent_id

    def initialize(parent_type, parent_id)
      @parent_type = parent_type
      @parent_id = parent_id
    end
  end
end