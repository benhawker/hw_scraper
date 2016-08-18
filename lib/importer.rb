class Importer
  attr_reader :city, :property_titles

  def initialize(city)
    @city = city
    @property_titles = []
  end
end
