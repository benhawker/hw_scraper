# Homeaway::Client: see top level +Client+ class
module Homeaway
  class Client < ::Client

    BASE_URL = "http://www.homeaway.com.sg/vacation-rentals/"

    private

    # Sample url: http://www.homeaway.com.sg/vacation-rentals/italy/rome?page=1
    def url_builder
      BASE_URL + CITIES["homeaway"][city] + "?" + "page=" + page.to_s
    end
  end
end