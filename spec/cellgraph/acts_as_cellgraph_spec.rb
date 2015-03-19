require "cellgraph"

module Cellgraph
  describe ActsAsCellgraph do
    with_model :StandardChildable do
      table do |t|
        t.string :parentable_type
        t.integer :parentable_id
      end

      model do |t|
        acts_as_cellgraph
      end
    end

    with_model :CustomizedChildable do
      table do |t|
        t.string :something_type
        t.integer :something_id
      end

      model do |t|
        acts_as_cellgraph cellgraph_field: :something
      end
    end

    with_model :NotChildable do
      table do |t|
        t.string :data
      end

      model do |t|
        acts_as_cellgraph
      end
    end

    class StandardChildableActor < EventInterface
      include Celluloid
    end

    class CustomizedChildableActor < EventInterface
      include Celluloid

      def deletable?(something)
        false
      end
    end

    class NotChildableActor < EventInterface
      include Celluloid
    end

    class ActorGroup < Celluloid::SupervisionGroup
      supervise StandardChildableActor, as: :standard_childable
      supervise CustomizedChildableActor, as: :customized_childable
      supervise NotChildableActor, as: :not_childable
    end


    before :example do
      Cellgraph.reset
      Celluloid.boot
    end

    after :example do
      Celluloid.shutdown
    end

    describe "model without customization" do
      it "uses :parentable" do
        expect(StandardChildable.cellgraph_field).to eq "parentable"
      end
    end

    describe "customized model" do
      it "uses :something" do
        expect(CustomizedChildable.cellgraph_field).to eq "something"
      end
    end

    describe "model without cellgraph_field" do
      it "has no field defined" do
        expect(NotChildable.send("method_defined?", NotChildable.cellgraph_field_id)).to be_falsey
      end
    end

    describe ".deletable" do
      it "calls has_null_cellgraph_field and query_deletion_listeners" do
        instance = StandardChildable.new
        expect(instance).to receive(:has_null_cellgraph_field).and_call_original
        expect(instance).to receive(:query_deletion_listeners).and_call_original
        instance.deletable?
      end
    end

    describe ".has_null_cellgraph_field" do
      it "return true when there is no parent, but a parent column is defined" do
        instance = StandardChildable.new
        expect(instance.send("has_null_cellgraph_field")).to be_truthy
      end
      it "return true when there is no parent or parent column present" do
        instance = NotChildable.new
        expect(instance.send("has_null_cellgraph_field")).to be_truthy
      end
      it "return false when there is a parent" do
        instance = StandardChildable.new
        instance.parentable_id = 1
        instance.parentable_type = "a"
        expect(instance.send("has_null_cellgraph_field")).to be_falsey
      end
    end

    describe ".query_deletion_listeners" do
      before {
        Cellgraph.configure do |config|
          config.mappings = {
            not_childable:
              [
                :standard_childable
              ]
          }
        end
        ActorGroup.run!
      }
      it "return true when there are no listener" do
        instance = StandardChildable.new # doesn't have any listener defined.
        expect(instance.send("query_deletion_listeners")).to be_truthy
      end
      it "disallows more than one listener" do
        Cellgraph.configure do |config|
          config.mappings = {
            not_childable:
              [
                :standard_childable,
                :customized_childable
              ]
          }
        end
        instance = NotChildable.new
        expect{instance.send("query_deletion_listeners")}.to raise_error
      end
      it "return true when no listener protests" do
        instance = NotChildable.new
        expect_any_instance_of(EventInterface).to receive(:deletable?).and_call_original
        expect(instance.send("query_deletion_listeners")).to be_truthy
      end
      it "returns false when a listener protests" do
        Cellgraph.configure do |config|
          config.mappings = {
            not_childable:
              [
                :customized_childable
              ]
          }
        end
        instance = NotChildable.new
        expect(instance.send("query_deletion_listeners")).to be_falsey
      end
    end

    describe "callbacks" do
      before {
        Cellgraph.configure do |config|
          config.mappings = {
            not_childable:
              [
                :standard_childable
              ]
          }
        end
        ActorGroup.run!
      }

      describe "saving with a parent" do
        it "should execute the after_save callback" do
          parent = NotChildable.new
          parent.save
          model = StandardChildable.new
          expect_any_instance_of(EventInterface).to receive(:addressed_saved).and_call_original
          model.parentable_type = "NotChildable"
          model.parentable_id = parent.id
          model.save
        end
      end

      describe "deleting with a parent" do
        it "should execute the after_save callback" do
          pending("Model callback executes in debug, but test fails with missing method..")
          model = StandardChildable.new
          model.save
          expect(model).to receive(:before_destroy).and_call_original
          model.destroy
        end
      end
    end


  end
end