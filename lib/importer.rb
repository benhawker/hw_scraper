class Importer
  attr_reader :city, :property_titles
  attr_accessor :max_page, :rooms_per_page

  def initialize(city)
    @city = city
    @property_titles = []
  end
end
