require "cellgraph"

module Cellgraph

  describe Configuration do
    before :each do
      Cellgraph.reset
    end

    describe ".reset" do
      before do
        Cellgraph.configure do |config|
          config.cellgraph_field = :something
        end
        expect(Cellgraph.configuration.cellgraph_field).to eq(:something)
      end

      it "resets the configuration" do
        Cellgraph.reset
        config = Cellgraph.configuration
        expect(config.cellgraph_field).to eq(:parentable)
      end
    end

    describe "#cellgraph_field" do
      it "defaults to parentable" do
        expect(Cellgraph.configuration.cellgraph_field).to eq(:parentable)
      end
    end

    describe "#cellgraph_field=" do
      it "can set value" do
        Cellgraph.configure do |config|
          config.cellgraph_field = :something
        end
        expect(Cellgraph.configuration.cellgraph_field).to eq(:something)
      end
    end

    describe "#mappings" do
      it "defaults to nothing" do
        expect(Cellgraph.configuration.mappings).to eq({})
      end
    end

    describe "#mappings=" do
      it "can set value" do
        Cellgraph.configure do |config|
          config.mappings = {
            listener:
              [
                :source_a,
                :source_b
              ]
          }

        end
        expect(Cellgraph.configuration.mappings).to eq({
              listener:
                [
                  :source_a,
                  :source_b
                ]
            })
      end
    end
  end
end
