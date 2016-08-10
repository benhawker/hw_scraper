# Read zh title from the RM database via a CSV we will regularly output.
# CSV will contain room_id, city (string), property title (in English)

class RMImporter
  attr_reader :property_titles

  def initialize
    @property_titles = []
  end

  # We will import properties.csv into the root periodically.
  def import
    CSV.foreach(path, headers: true, quote_char: "|") do |record|
      hash = { :title => record['title'], :rm_id => record['room_id'] }

      property_titles << hash
    end
    property_titles
  end

  def path
    "properties/rome.csv"
  end
end