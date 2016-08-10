class PageRankExporter
  attr_reader :grouped_counts

  def initialize(grouped_counts)
    @grouped_counts = grouped_counts
  end

  def export
    return if grouped_counts.empty?
    create_dir

    CSV.open(path_filename, "w+", headers: true, headers: ["Page", "RM Properties Found"]) do |csv|
      grouped_counts.each do |page_record|
        csv << page_record
      end
    end
  end

  private

  def path_filename
    "#{path}page_rank_#{Date.today}.csv"
  end

  def path
    "results/"
  end

  def create_dir
    FileUtils.mkdir_p(path)
  end
end
