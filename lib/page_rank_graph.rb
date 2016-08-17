class PageRankGraph
  PIXEL_WIDTH = 750

  attr_reader :counts, :graph

  #Presume class will accept hash of page to found count. { 1 => 0, 2 => 3, 3 => 4, etc.}
  def initialize(counts, city)
    @counts = counts
    @graph = Gruff::Bar.new(PIXEL_WIDTH)
  end

  def build
    return if counts.empty?
    create_dir

    build_x_axis
    build_y_axis
    build_titles
    graph.write(File.join(path_filename))
  end

  private

  def build_x_axis
    determine_scale
  end

  def build_y_axis
    graph.maximum_value = 20  # Declare a max value for the Y axis - i.e. max number of rooms per page.
    # TODO = Pull this max per page from the client class once adding different partners.
    graph.minimum_value = 0   # Declare a min value for the Y axis
    graph.y_axis_increment = 5  # Points shown on the Y x_axis
  end

  def determine_scale
    if counts.size > 200
      scale = 20
    elsif counts.size > 100
      scale = 10
    elsif counts.size > 50
      scale = 3
    else counts.size
      scale = 1
    end

    scale_labels(scale)
    scale_data(scale)
  end

  def scale_data(scale)
    scaled_array = []

    counts.values.each_slice(scale) do |chunk|
      scaled_array << chunk.inject(:+)
    end

    graph.data('Data', scaled_array)
  end

  def scale_labels(scale)
    start_of_range = 1
    labels_hash = {}

    (counts.size / scale).times do |i|
      if scale == 1
        labels_hash[i] = "#{start_of_range}"
      else
        labels_hash[i] = "#{start_of_range}-#{start_of_range + scale - 1}"
      end

      start_of_range += scale
    end

    graph.labels = labels_hash
  end

  def build_titles
    graph.x_axis_label = "Page Number"
    graph.y_axis_label = "Properties Found"
    graph.title = "Rome Page Rank #{Date.today}"
  end

  def path_filename
    "#{path}page_rank_#{Date.today}.png"
  end

  def path
    "results/graphs"
  end

  def create_dir
    FileUtils.mkdir_p(path)
  end
end