require "spec_helper"

describe Cellgraph::Mock::Listener do
  describe "#invoked_times" do
    let(:testee) { described_class.new }

    context "when created invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.created(nil) } }
      it "counts up 'created' invoked times" do
        expect(testee.invoked_times(:created)).to eq count
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when addressed_created invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.addressed_created(nil, nil, nil) } }
      it "counts up 'addressed_created' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq count
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when updated invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.updated(nil) } }
      it "counts up 'updated' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq count
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when addressed_updated invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.addressed_updated(nil, nil, nil) } }
      it "counts up 'addressed_updated' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq count
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when deleted invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.deleted(nil) } }
      it "counts up 'deleted' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq count
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when addressed_deleted invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.addressed_deleted(nil, nil, nil) } }
      it "counts up 'addressed_deleted' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq count
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when deletable? invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.deletable?(nil) } }
      it "counts up 'deletable?' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq count
        expect(testee.invoked_times(:addressed_deletable?)).to eq 0
      end
    end

    context "when addressed_deletable? invoked" do
      let(:count) { rand(1..10) }
      before { count.times { testee.addressed_deletable?(nil, nil, nil) } }
      it "counts up 'addressed_deletable?' invoked times" do
        expect(testee.invoked_times(:created)).to eq 0
        expect(testee.invoked_times(:addressed_created)).to eq 0
        expect(testee.invoked_times(:updated)).to eq 0
        expect(testee.invoked_times(:addressed_updated)).to eq 0
        expect(testee.invoked_times(:deleted)).to eq 0
        expect(testee.invoked_times(:addressed_deleted)).to eq 0
        expect(testee.invoked_times(:deletable?)).to eq 0
        expect(testee.invoked_times(:addressed_deletable?)).to eq count
      end
    end
  end
end
