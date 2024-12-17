class Reader

  def self.call(file_path)
    # read each line from file
    File.open(file_path, 'r') do |file|
      file.each_line do |line|
        yield(line)
      end
    end
  end

end