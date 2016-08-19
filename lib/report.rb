class Report
  # Entry point of this application.
  # Pass a partners array as an args to narrow down the scope of the report.
  # To narrow down the cities selected please amend the cities.yml before requiring the application.

  def self.generate(partners=nil)
    new(partners).generate!
  end

  CITIES = YAML::load(File.open(File.join('config', 'cities.yml')))
  PARTNERS = YAML::load(File.open(File.join('config', 'partners.yml')))

  attr_reader :partners

  def initialize(partners=nil)
    @partners = partners || PARTNERS
  end

  def generate!
    raise InvalidPartnerRequested.new(partners) unless valid_partners?(partners)

    partners.each do |partner|
      CITIES[partner].keys.each do |city|
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