require "spec_helper"

describe Cellgraph do
  describe "#dispatcher" do
    subject { described_class.dispatcher }
    it { is_expected.to be_a Cellgraph::Dispatcher }
    it { is_expected.to eq described_class.configuration.dispatcher }
  end

  describe "#mock!" do
    subject { described_class.mock! }

    it "changes dispatcher instance" do
      expect(described_class.dispatcher).to be_a Cellgraph::Dispatcher
      subject
      expect(described_class.dispatcher).to be_a Cellgraph::Mock::Dispatcher
    end
  end
end
