class Reader

  def self.call(file_path)
    map = []

    # read each line from file and put numbers in needed arrays
    File.open(file_path, 'r') do |file|
      file.each_line do |line|
        map << line.strip.chars
      end
    end

    map
  end

end