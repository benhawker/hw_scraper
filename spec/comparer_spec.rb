require "spec_helper"

RSpec.describe Comparer do
  let(:partner) { "tujia" }
  let(:city) { "london" }

  let(:partner_properties) { [{"title"=>"牛津街考文特花园完美伦敦公寓", "page"=>1}, {"title"=>"1号曼斯里大厦三室两卫公寓", "page"=>1}] }
  let(:rm_properties) { [{:title=>"title_1", :rm_id=>"1", :city=>"london"}, {:title=>"title_2", :rm_id=>"2", :city=>"london"}] }

  describe "#compare" do
    before do
      allow_any_instance_of(described_class).to receive(:rm_properties).and_return(rm_properties)
      allow_any_instance_of(described_class).to receive(:partner_properties).and_return(partner_properties)

      Tujia::Importer.any_instance.stub(:max_page).and_return(3)
      Tujia::Importer.any_instance.stub(:rooms_per_page).and_return(20)
    end

    it "correctly populates the output" do
      expected_result = [{:rm_id=>"1", :title=>"title_1", :page=>"Not Found"}, {:rm_id=>"2", :title=>"title_2", :page=>"Not Found"}]
      subject = described_class.new(partner, city)
      subject.compare
      expect(subject.output).to eq (expected_result)
    end
  end
end