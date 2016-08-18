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
