class RawExporter
  attr_reader :partner_name, :city, :output

  def initialize(partner_name, city, output)
    @partner_name = partner_name
    @city = city
    @output = output
  end

  def export
    return if output.empty?
    create_dir

    CSV.open(path_filename, "w+", headers: true, headers: output.first.keys) do |csv|
      output.each do |record|
        csv << record.values
      end
    end
  end

  private

  def path_filename
    "#{path}/#{city}_raw_#{Date.today}.csv"
  end

  def path
    "results/#{partner_name}/raw"
  end

  def create_dir
    FileUtils.mkdir_p(path)
  end
end
