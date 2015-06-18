module Cellgraph
  class DependentsPresentError < StandardError
    attr_reader :dependents

    def initialize(dependents)
      @dependents = dependents
    end
  end
end