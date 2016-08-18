module Homeaway
  class Importer < ::Importer

    def import
      # Hardcoded the max page for Rome search results (347) for now.
      #TODO - Crawl until we reach the end.
      1.upto(3).each do |page_number|
        page = get_page(page_number)

        #Defaults to 20 rooms per page.
        #TODO - Crawl the correct number of properties based on the page that is returned.
        1.upto(20).each do |i|
          attributes =  { :title => page.css("#space-#{i} > div.data.col-sm-7 > div > div.details.primary > h4").text, :page => page_number}
          property_titles << attributes

          self.rooms_per_page = 20 #Store the rooms per page.
        end

        self.max_page = page_number
      end
      property_titles
    end
    # Return [{"title"=>"ABC", "page"=>1}, {"title"=>"XYZ", "page"=>1}]

    private

    def get_page(page_number)
      Homeaway::Client.new(city, page_number).get
    end
  end
end