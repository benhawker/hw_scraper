class Report
  # Entry point of this application.
  # Pass a partners array and a cities array as args to narrow down the scope of the report.

  def self.generate(partners=nil, cities=nil)
    new(partners, cities).generate!
  end

  CITIES = YAML::load(File.open(File.join('config', 'cities.yml')))
  PARTNERS = YAML::load(File.open(File.join('config', 'partners.yml')))

  attr_reader :partners, :cities

  def initialize(partners=nil, cities=nil)
    @cities = cities || CITIES.keys
    @partners = partners || PARTNERS
  end

  def generate!
    raise InvalidPartnerRequested.new(partners) unless valid_partners?(partners)

    partners.each do |partner|
      # TODO - Incorporate ability to pass selected cities.
      CITIES[partner].keys.each do |city|
        raise InvalidCityForPartner.new(partner, city) unless valid_city_for_partner?(partner, city)

        Comparer.new(partner, city).compare
      end
    end
  end

  private

  def valid_partners?(partners)
    partners.each do |partner|
      return false unless PARTNERS.include?(partner)
    end
  end

  def valid_city_for_partner?(partner, city)
    return false unless CITIES[partner].keys.include?(city)
  end
end