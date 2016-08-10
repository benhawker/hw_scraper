class HWImporter
  attr_reader :property_titles

  def initialize
    @property_titles = []
  end

  def import
    # Hardcoded the max page for Rome search results
    1.upto(347).each do |page_number|
      page = get_page(page_number)

      #Defaults to 20 rooms per page.
      1.upto(20).each do |i|
        attributes =  { :title => page.css("#space-#{i} > div.data.col-sm-7 > div > div.details.primary > h4").text, :page => page_number}
        property_titles << attributes
      end
    end
    property_titles
  end

  private

  def get_page(page_number)
    Client.new(page_number).get
  end
end