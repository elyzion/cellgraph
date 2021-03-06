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
        acts_as_cellgraph :parentless
      end
    end

    class StandardChildableListener < EventInterface
    end

    class CustomizedChildableListener < EventInterface

      def deletable?(something)
        false
      end
    end

    class NotChildableListener < EventInterface
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
        expect(NotChildable.send("method_defined?", "cellgraph_field_id")).to be_falsey
      end
    end

    describe "various model forms can be used at the same time" do
      it "uses :parentable" do
        expect(StandardChildable.cellgraph_field).to eq "parentable"
      end
      it "uses :something" do
        expect(CustomizedChildable.cellgraph_field).to eq "something"
      end
      it "has no field defined" do
        expect(NotChildable.send("method_defined?", "cellgraph_field_id")).to be_falsey
      end
    end

    describe ".deletable" do
      it "calls has_null_cellgraph_field and query_deletion_listeners" do
        instance = StandardChildable.new
        expect(instance).to receive(:has_null_cellgraph_field!).and_return(true)
        expect(instance).to receive(:query_deletion_listeners).and_return(true)
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
      it "return ParentPresentError when there is a parent" do
        instance = StandardChildable.new
        instance.parentable_id = 1
        instance.parentable_type = "a"
        expect{instance.send("has_null_cellgraph_field!")}.to raise_error(ParentPresentError)
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
          Cellgraph.dispatcher.register_listener(:standard_childable, StandardChildableListener.new)
        end
      }
      it "return true when there are no listener" do
        instance = StandardChildable.new # doesn't have any listener defined.
        expect(instance.send("query_deletion_listeners")).to be_truthy
      end
      it "return true when no listener protests" do
        instance = NotChildable.new
        expect_any_instance_of(EventInterface).to receive(:deletable?).and_return(true)
        expect(instance.send("query_deletion_listeners")).to be_truthy
      end
      it "returns DependentPresentError when a listener protests" do
        Cellgraph.configure do |config|
          config.mappings = {
            not_childable:
              [
                :customized_childable
              ]
          }
          Cellgraph.dispatcher.register_listener(:customized_childable, CustomizedChildableListener.new)
        end
        instance = NotChildable.new
        expect{instance.send("query_deletion_listeners")}.to raise_error(DependentsPresentError)
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
          Cellgraph.dispatcher.register_listener(:standard_childable, StandardChildableListener.new)
          Cellgraph.dispatcher.register_listener(:not_childable, NotChildableListener.new)
        end
      }

      describe "saving with a parent" do
        it "should execute the addressed_saved callback" do
          parent = NotChildable.new
          parent.save
          model = StandardChildable.new
          expect_any_instance_of(EventInterface).to receive(:addressed_created).and_return(true)
          model.parentable_type = "NotChildable"
          model.parentable_id = parent.id
          model.save
        end
      end

      describe "deleting a parent" do
        it "frees the child" do
          parent = NotChildable.new
          parent.save
          model = StandardChildable.new
          model.parentable_type = "NotChildable"
          model.parentable_id = parent.id
          model.save

          expect_any_instance_of(EventInterface).to receive(:deleted).and_return(true)
          parent.destroy
        end
      end
    end

  end
end
