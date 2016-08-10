class RawExporter
  attr_reader :output

  def initialize(output)
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
    "#{path}raw_#{Date.today}.csv"
  end

  def path
    "results/"
  end

  def create_dir
    FileUtils.mkdir_p(path)
  end
end
