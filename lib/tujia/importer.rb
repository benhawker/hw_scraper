# Tujia::Importer: see top level +Importer+ class
module Tujia
  class Importer < ::Importer

    def import
      # Don't just silently fail collecting titles if the page structure changes on the partner site.
      raise PageStructureChanged.new("Tujia") if get_page(1).css("#idForMap > div > ul > li > div > div.main-cont > h2 > a").empty?

      page_number = 1

      until get_page(page_number).css("#idForMap > div > ul > li > div > div.main-cont > h2 > a").empty?
        links = get_page(page_number).css("#idForMap > div > ul > li > div > div.main-cont > h2 > a")

        links.each do |link|
          property_title = link.attributes["title"].value
          property_titles << { :title => property_title, :page => page_number}
        end

        page_number += 1
      end

      self.rooms_per_page = 20 #Store the rooms per page. Arbitrary number for now.
      self.max_page = page_number

      property_titles
    end
    # Return [{"title"=>"牛津街考文特花园完美伦敦公寓", "page"=>1}, {"title"=>"1号曼斯里大厦三室两卫公寓", "page"=>1}]

    private

    def get_page(page_number)
      Tujia::Client.new(city, page_number).get
    end
  end
end