class Comparer
  attr_reader :rm, :hw, :output
  attr_accessor :number_of_rm_properties_found

  def initialize
    @rm = rm_properties
    @hw = hw_properties
    @output = []
  end

  def compare
    found
    not_found

    export_summary
    export_page_ranking(grouped_counts)
    export_raw(output)
  end

  private

  def found
    found_count = 0

    rm.each do |rm_property|
      hw.each do |hw_property|

        #Strip whitespace to ensure we are comparing the same things - allows for formatting issues.
        rm_title = rm_property[:title].strip unless rm_property[:title].nil?
        hw_title = hw_property[:title].strip unless hw_property[:title].nil?

        #Do not add the second match - due to the nested iteration.
        if (rm_title == hw_title) && !output.any? {|h| h[:title] == rm_property[:title]}
          output << { :rm_id => rm_property[:rm_id], :title => rm_property[:title], :page => hw_property[:page] }
          found_count += 1
        end
      end
    end
    @number_of_rm_properties_found = found_count
  end

  def not_found
    titles = []
    hw.each { |t| titles << t[:title] }

    rm.each do |rm_property|
      unless titles.include?(rm_property[:title])
        output << { :rm_id => rm_property[:rm_id], :title => rm_property[:title], :page => "Not Found" }
      end
    end
  end

  def rm_properties
    RMImporter.new.import
  end

  def hw_properties
    HWImporter.new.import
  end

  # Total number of properties shown for given the give destination at Tujia.com
  def number_of_hw_properties
    hw.size
  end

  # Total number of properties contained in CSV dump for the given destination that meet
  # the scope (included in the feed) as defined by the Feed application.
  def number_of_rm_properties
    rm.size
  end

  def percentage_of_properties_found
    ((number_of_rm_properties_found.to_f / number_of_rm_properties.to_f) * 100).round(2)
  end

  def percentage_of_roomorama_properties_out_of_total_on_hw
    ((number_of_rm_properties_found.to_f / number_of_hw_properties.to_f) * 100).round(2)
  end

  def export_raw(output)
    RawExporter.new(output).export
  end

  def summary_hash
    {
      :type => "Rome - HomeAway Search Result Title Comparison",
      :date => Date.today,
      :number_of_hw_properties => number_of_hw_properties,
      :number_of_rm_properties => number_of_rm_properties,
      :number_of_rm_properties_found => number_of_rm_properties_found,
      :percentage_of_properties_found => percentage_of_properties_found,
      :percentage_of_roomorama_properties_out_of_total_on_hw => percentage_of_roomorama_properties_out_of_total_on_hw
    }
  end

  def export_summary
    Summarizer.new(summary_hash).export
  end

  # Returns an array of arrays with page rank and number of properties on that page. ["Page 1", "1 RM properties"]
  def grouped_counts
    counted = Hash.new(0)
    output.each { |h| counted[h[:page]] += 1 }

    # Delete Not Found before sorting
    deleted = counted.delete("Not Found")

    # Sort by the keys.
    counted = Hash[counted.sort_by{|k,v| k}]

    # Add the Not Found k,v pair back in
    counted["Not Found"] = deleted

    #Some hacky text formatting to provide [["Page 1", "1 RM properties"], ["Not Found", "52 RM properties"]] to PageRankExporter
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

  def export_page_ranking(grouped_counts)
    PageRankExporter.new(grouped_counts).export
  end
end