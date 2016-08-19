class PageRankExporter
  attr_reader :partner_name, :city, :grouped_counts

  def initialize(partner_name, city, grouped_counts)
    @partner_name = partner_name
    @city = city
    @grouped_counts = grouped_counts
  end

  def export
    return if grouped_counts.empty?
    create_dir

    CSV.open(path_filename, "w+", headers: true) do |csv|
      grouped_counts.each do |elem|
        csv << elem
      end
    end
  end

  private

  def path_filename
    "#{path}/#{city}_page_rank_#{Date.today}.csv"
  end

  def path
    "results/#{partner_name}/page_rank_data"
  end

  def create_dir
    FileUtils.mkdir_p(path)
  end
end