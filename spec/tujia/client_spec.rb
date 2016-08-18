require "spec_helper"

RSpec.describe Tujia::Client do

  let(:city) { "london" }
  subject { described_class.new(city) }

  describe "#get" do
    # Add VCR before making this live.
    xit "returns a response from Tujia as a Mechanize object" do
      expect(subject.get).to be_instance_of Mechanize::Page
    end
  end
end
