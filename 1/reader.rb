class Reader

  def self.call(file_path)
    left_list = []
    right_list = []

    # read each line from file and put numbers in needed arrays
    File.open(file_path, 'r') do |file|
      file.each_line do |line|
        numbers = line.strip.split
        if numbers.length == 2
          left_list << numbers[0].to_i
          right_list << numbers[1].to_i
        end
      end
    end

    [left_list, right_list]
  end

end