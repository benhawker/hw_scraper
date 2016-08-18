module Homeaway
  class Importer < ::Importer

    def import
      # Hardcoded the max page for Rome search results (347)
      #TODO
      1.upto(2).each do |page_number|
        page = get_page(page_number)

        #Defaults to 20 rooms per page.
        #TODO
        1.upto(20).each do |i|
          attributes =  { :title => page.css("#space-#{i} > div.data.col-sm-7 > div > div.details.primary > h4").text, :page => page_number}
          property_titles << attributes
        end
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