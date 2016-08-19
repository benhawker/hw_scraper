# Importer: the importer class retrieves the property titles for the page object provided by the client.
#
# The +Importer+ needs to be tailored for each partner under the relevant namespace (e.g. Tujia::Importer)
# It makes available the property_titles array contaning a hash for each property we scrape.
# Usage:
#
#   Tujia::Importer.new("london").import

class Importer
  attr_reader :city, :property_titles
  attr_accessor :max_page, :rooms_per_page

  def initialize(city)
    @city = city
    @property_titles = []
  end
end
