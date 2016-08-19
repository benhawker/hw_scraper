# Summarizer: the Summarizer class prints to a txt file a simple summary of key metrics for each city sraped, imported and compared.
#
# Giving output such as the below:
#     type: Rome - Homeaway Search Result Title Comparison
#     date: 2016-08-19
#     number_of_homeaway_properties: 6700
#     number_of_rm_properties: 526
#     number_of_rm_properties_found: 231
#     percentage_of_properties_found: 43.92
#     percentage_of_rm_properties_out_of_total_on_homeaway: 3.45
#
# Usage:
#
#   Summarizer.new("tujia", summary_hash)
#
# The summary_hash is built by the +Comparer+ class as the part of the `compare` method. See that class for the details of it's implementation.

class Summarizer
  attr_reader :partner_name, :summary

  def initialize(partner_name, summary)
    @partner_name = partner_name
    @summary = summary
  end

  def export
    create_dir

    File.open(path_filename, 'a+') do |file|
      summary.each do |key, value|
        file.write("#{key}: #{value}\n")
      end
      file.write("\n")
    end
  end

  private

  def path_filename
    "#{path}/summary_#{Date.today}.txt"
  end

  def path
    "results/#{partner_name}/summaries"
  end

  def create_dir
    FileUtils.mkdir_p(path)
  end
end
