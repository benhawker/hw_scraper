# Comparer: the Comparer class does the bulk of the analysis of the data imported.
#
# Usage:
#   Comparer.new("tujia", "london").compare
#
# The +Comparer+ class instantiates the importer (both Rm and Parter variants).
# The public compare method wraps a number of private methods with determine which properties we
# find on the partner site and where, or indeed whether they were not found.
#
# It then exports the outputs via the exporter classes.

class Comparer
  attr_reader :city, :partner_name, :rm_properties, :partner_properties, :output
  attr_accessor :number_of_rm_properties_found

  def initialize(partner_name, city)
    @city = city
    @partner_name = partner_name

    @rm_properties = rm_props
    @partner_properties = partner_props

    @output = []
  end

  def compare
    found
    not_found

    export_summary
    export_page_ranking(counts_with_formatting)
    export_page_rank_graph(counts)
    export_raw(output)
  end

  private

  # RM Importer #

  def rm_props
    rm_importer.import
  end

  def rm_importer
    RmImporter.new(partner_name, city)
  end

  # Partner Importer #

  def partner_props
   partner_importer.import
  end

  def partner_importer
    @importer ||= partner_namespace::Importer.new(city)
    # @importer ||= partner_namespace::Importer.new(city)
  end

  def partner_namespace
    partner_name.capitalize.constantize
  end

  # Send various outputs to the exporter classes #

  def export_summary
    Summarizer.new(partner_name, summary_hash).export
  end

  def export_page_ranking(counts_with_formatting)
    PageRankExporter.new(partner_name, city, counts_with_formatting).export
  end

  def export_page_rank_graph(counts)
    PageRankGraph.new(partner_name, city, counts, rooms_per_page).build
  end

  def export_raw(output)
    RawExporter.new(partner_name, city, output).export
  end

  # Compare and calculate the outputs that the exporter classes accept as inputs #

  def found
    found_count = 0

    rm_properties.each do |rm_property|
      partner_properties.each do |partner_property|

        #Strip whitespace to ensure we are comparing the same things - allows for formatting issues.
        rm_title = rm_property[:title].strip unless rm_property[:title].nil?
        partner_title = partner_property[:title].strip unless partner_property[:title].nil?

        #Do not add the second match - due to the nested iteration.
        if (rm_title == partner_title) && !output.any? {|h| h[:title] == rm_property[:title]}
          output << { :rm_id => rm_property[:rm_id], :title => rm_property[:title], :page => partner_property[:page] }
          found_count += 1
        end
      end
    end
    @number_of_rm_properties_found = found_count
  end

  def not_found
    titles = []
    partner_properties.each { |t| titles << t[:title] }

    rm_properties.each do |rm_property|
      unless titles.include?(rm_property[:title])
        output << { :rm_id => rm_property[:rm_id], :title => rm_property[:title], :page => "Not Found" }
      end
    end
  end

  # Total number of properties shown for given the give destination at Tujia.com
  def number_of_partner_properties
    partner_properties.size
  end

  # Total number of properties contained in CSV dump for the given destination that meet
  # the scope (included in the feed) for the given partner.
  def number_of_rm_properties
    rm_properties.size
  end

  def percentage_of_properties_found
    ((number_of_rm_properties_found.to_f / number_of_rm_properties.to_f) * 100).round(2)
  end

  def percentage_of_roomorama_properties_out_of_total_on_partner_site
    ((number_of_rm_properties_found.to_f / number_of_partner_properties.to_f) * 100).round(2)
  end

  def rooms_per_page
    partner_importer.rooms_per_page
  end

  def summary_hash
    {
      :type => "#{city.capitalize} - #{partner_name.capitalize} Search Result Title Comparison",
      :date => Date.today,
      "number_of_#{partner_name}_properties".to_sym => number_of_partner_properties,
      :number_of_rm_properties => number_of_rm_properties,
      :number_of_rm_properties_found => number_of_rm_properties_found,
      :percentage_of_properties_found => percentage_of_properties_found,
      "percentage_of_rm_properties_out_of_total_on_#{partner_name}".to_sym => percentage_of_roomorama_properties_out_of_total_on_partner_site
    }
  end

  # Returns an array of arrays with page rank and number of properties on that page. ["Page 1", "1 RM properties"]
  def counts_with_formatting
    counted = Hash.new(0)
    output.each { |h| counted[h[:page]] += 1 }
    # Delete Not Found before sorting
    deleted = counted.delete("Not Found")
    # Sort by the keys.
    counted = Hash[counted.sort_by{|k,v| k}]
    # Add the Not Found k,v pair back in
    counted["Not Found"] = deleted

    #Some text formatting to provide [["Page 1", "1 RM properties"], ["Not Found", "52 RM properties"]] to PageRankExporter
    counted.to_a.map! do |arr|
      arr.map! do |el|
        if el == "Not Found"
          "Not Found"
        elsif arr.index(el) == 0
          "Page #{el}"
        elsif arr.index(el) == 1
          "#{el} RM properties"
        end
      end
    end
  end

  # Returns a hash with page as the key, properties found as the value {1=>1, 2=>0, 3=>0}
  def counts
    # 1 upto max page (made available from the relevant importer class)
    counted = Hash[1.upto(partner_importer.max_page).map {|i| [i, 0]}]
    # Delete Not Found - it's not needed for the graph.
    tmp = output.select { |h| h[:page] != "Not Found" }
    # Sum the counts in the counted hash
    tmp.each { |h| counted[h[:page].to_i] += 1 }
    #Return counted hash
    counted
  end
end