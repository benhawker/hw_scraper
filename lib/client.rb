# Client: makes the connection to the partner site.
#
# The +Client+ class is returning a +Mechanize+ page object which will be utilized by the Importer.

class Client
  CITIES = YAML::load(File.open(File.join('config', 'cities.yml')))

  attr_reader :city, :page

  def initialize(city, page=1)
    @city = city
    @page = page
  end

  def get
    http_client.get(url_builder)
  end

  private

  def http_client
    Mechanize.new
  end
end
