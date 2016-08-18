# Read zh title from the RM database via a CSV we will regularly output.
# CSV will contain room_id, city (string), property title (in English)

class RmImporter
  attr_reader :partner_name, :city, :property_titles

  def initialize(partner_name, city)
    @partner_name = partner_name
    @city = city
    @property_titles = []
  end

  # Requires periodic import of properties.csv for each partner added.
  def import
    CSV.foreach(path, headers: true, quote_char: "|") do |record|
      if record['city'] == city.to_s
        hash = { :title => record['title'], :rm_id => record['room_id'], :city => record['city'] }

        property_titles << hash
      end
    end
    property_titles
  end

  def path
    "properties/#{partner_name}/properties.csv"
  end
end