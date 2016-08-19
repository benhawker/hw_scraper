# Homeaway::Importer: see top level +Importer+ class
module Homeaway
  class Importer < ::Importer

    def import
      # Don't just silently fail collecting titles if the page structure changes on the partner site.
      raise PageStructureChanged.new("Homeaway") if get_page(1).css("#space-1 > div.data.col-sm-7 > div > div.details.primary > h4").empty?

      # Get the first page and get the button specify the final page. A little brittle but working for now.
      last_page_number = get_page(1).css("#paginator > div > div > ul > li:nth-child(6) > a").text.to_i

      # 1.upto(last_page_number).each do |page_number|
      1.upto(last_page_number).each do |page_number|
        page = get_page(page_number)

        #Defaults to 20 rooms per page. TODO - Crawl the correct number of properties based on the page that is returned.
        1.upto(20).each do |i|
          attributes =  { :title => page.css("#space-#{i} > div.data.col-sm-7 > div > div.details.primary > h4").text, :page => page_number}
          property_titles << attributes
        end
      end
      self.rooms_per_page = 20 #Store the rooms per page.
      self.max_page = last_page_number
      property_titles
    end
    # Return [{"title"=>"ABC", "page"=>1}, {"title"=>"XYZ", "page"=>1}]

    private

    def get_page(page_number)
      Homeaway::Client.new(city, page_number).get
    end
  end
end