module Tujia
  class Client < ::Client

    BASE_URL = "http://international.tujia.com/"

    private

    # Example: http://international.tujia.com/basailuona_gongyu_r24/1
    def url_builder
      BASE_URL + CITIES["tujia"][city] + page.to_s
    end
  end
end