require "rubygems"
require "active_support/inflector"
require "mechanize"
require "csv"
require "json"
require "fileutils"
require "gruff"
require "yaml"


require_relative "lib/client"
require_relative "lib/importer"
require_relative "lib/rm_importer"
require_relative "lib/comparer"
require_relative "lib/summarizer"
require_relative "lib/page_rank_exporter"
require_relative "lib/raw_exporter"
require_relative "lib/page_rank_graph"

require_relative "lib/homeaway/client"
require_relative "lib/homeaway/importer"

require_relative "lib/tujia/client"
require_relative "lib/tujia/importer"

require_relative "lib/report"

class InvalidCityForPartner < StandardError
  def initialize(partner, city)
    super("#{city} is not a valid city for #{partner}. Valid cities for #{partner} are: #{Report::CITIES[partner].keys}")
  end
end

class InvalidPartnerRequested < StandardError
  def initialize(partners)
    super("One of your requested partners: #{partners} is not valid. Valid partners are: #{Report::PARTNERS}")
  end
end