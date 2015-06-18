module Cellgraph
  class ParentPresentError < StandardError
    attr_reader :parent_type

    def initialize(parent_type)
      @parent_type = parent_type
    end
  end
end