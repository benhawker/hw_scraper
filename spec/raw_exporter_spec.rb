require "spec_helper"

RSpec.describe RawExporter do
  let(:output) { [{ :rm_id => 123, :title => "my title", :page => 1, :city => "london" }, { :rm_id => 234, :title => "my title2", :page => 2, :city => "london" }] }

  let(:partner) { "tujia" }
  let(:city) { "london" }
  subject { described_class.new(partner, output) }

  describe "#export" do
    before do
      allow(subject).to receive(:path_filename).and_return("spec/assets/results/my_test_csv.csv")
      subject.export
    end

    it "creates a csv and writes the results to it" do
      file = File.read("spec/assets/results/my_test_csv.csv")
      expect(file).to include ("123,my title,1,london\n234,my title2,2,london")
    end

    after do
      File.delete("spec/assets/results/my_test_csv.csv")
    end
  end
end