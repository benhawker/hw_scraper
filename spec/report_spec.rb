require "spec_helper"

RSpec.describe Report do
  let(:partners) { ["tujia"] }
  subject { described_class.new(partners, cities) }

  describe "#generate!" do
    it "raises an error if the city is not specified for the given partner" do
      error_message = 'london is not a valid city for tujia. Valid cities for tujia are: ["london", "singapore", "tokyo", "osaka", "seoul", "jeju island", "pattaya", "bangkok", "chiang mai", "phuket"]'
      cities = ["Moscow"]
      expect { described_class.new(partners).generate! }.to raise_error(error_message)
    end

    it "raises an error if the city is not specified for the given partner" do
      error_message = 'One of your requested partners: ["bad_partner"] is not valid. Valid partners are: ["homeaway", "tujia"]'
      expect { described_class.new(["bad_partner"]).generate! }.to raise_error(error_message)
    end
  end
end