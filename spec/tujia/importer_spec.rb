require "spec_helper"

RSpec.describe Tujia::Importer do

  let(:city) { "london" }
  subject { described_class.new(city) }

  describe "#get_property_titles" do
    before do
      response = [{"title"=>"牛津街考文特花园完美伦敦公寓", "page"=>1}, {"title"=>"1号曼斯里大厦三室两卫公寓", "page"=>1}]
      allow(subject).to receive(:get_property_titles).and_return(response)
    end

    it "returns a hash with the scraped property title and page it was found on in the search results" do
      expect(subject.get_property_titles).to eq ([{"title"=>"牛津街考文特花园完美伦敦公寓", "page"=>1}, {"title"=>"1号曼斯里大厦三室两卫公寓", "page"=>1}])
    end
  end
end