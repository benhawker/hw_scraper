class Client
  # http://www.homeaway.com.sg/vacation-rentals/italy/rome?page=1
  BASE_URL = "http://www.homeaway.com.sg/vacation-rentals/"

  attr_reader  :page

  def initialize(page=1)
    @page = page
  end

  def get
    http_client.get(url_builder)
  end

  private

  def http_client
    Mechanize.new
  end

  def url_builder
    BASE_URL + "italy/rome" + "?" + "page=" + page.to_s
  end
end
