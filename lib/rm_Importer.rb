# RmImporter: the RmImporter class reads from the specified csv stored at
#     +/properties/partner_name/properties.csv+
#
# The RmImporter will read the room_id, city and property_title in the given language.
#
# The CSV must be formed like so with the following headers:
#    room_id,city,title
#    246147,rome,St. Peter Awesome Family Apartment
#    338741,rome,Penthouse + Eagle Eye Attic Combo
#
# This file must be updated prior to running the script to synchronise
# expected properties vs. ones we find on partner sites.
#
# Usage:
#
#   RmImporter.new("tujia", "london").import
#
# The +RmImporter+ class then makes the property_titles array (of hashes) available to the +Comparer+ class.

class RmImporter
  attr_reader :partner_name, :city, :property_titles

  def initialize(partner_name, city)
    @partner_name = partner_name
    @city = city
    @property_titles = []
  end

  # Requires periodic import of properties.csv into prorerties/partner_name/ for each partner added.
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