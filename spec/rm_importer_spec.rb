require "spec_helper"

RSpec.describe RmImporter do

  let(:partner) { "tujia" }
  let(:city) { "london" }
  subject { described_class.new(partner,city) }


  describe "#import" do
    context "for the given city" do
      before do
        allow(subject).to receive(:path).and_return("spec/assets/properties.csv")
      end

      it "returns a hash" do
        property_titles_array_of_hashes = [{:title=>"title_1", :rm_id=>"1", :city=>"london"}, {:title=>"title_2", :rm_id=>"2", :city=>"london"}]
        expect(subject.import).to eq (property_titles_array_of_hashes)
      end
    end

    context "for another city" do
      it "it does not include it in the returned hash" do
        expect(subject.import).not_to include ("osaka")
      end
    end

    context "when the csv is invalid" do
      before do
        allow(subject).to receive(:path).and_return("spec/assets/invalid_properties.csv")
      end

      it "returns an error" do
        subject.stub(:import).and_return "Malformed CSV"
        expect(subject.import).to eq "Malformed CSV"
      end
    end
  end
end