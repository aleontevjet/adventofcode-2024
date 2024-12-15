
def calculate_stones_count(iterations)
  hash = {20 => 1, 82084 => 1, 1650 => 1, 3 => 1, 346355 => 1, 363 => 1, 7975858 => 1, 0 => 1}

  iterations.times do |time|
    hash = hash.each_with_object({}) do |(number, count), result|
      if number.zero?
        add_or_increment(result, 1, count)
      elsif number.to_s.size.even?
        str = number.to_s
        size = str.size
        mid = size / 2

        first_half = str.slice(0, mid).to_i     # Первая половина
        second_half = str.slice(mid, size).to_i # Вторая половина

        add_or_increment(result, first_half, count)
        add_or_increment(result, second_half, count)

      else
        new_number = number * 2024
        add_or_increment(result, new_number, count)
      end
    end

    puts "Моргание #{time + 1}: #{hash.inspect}"

  end

  hash.values.sum

end

def add_or_increment(hash, number, count)
  if hash[number].nil?
    hash[number] = count
  else
    hash[number] += count
  end
end

total_stones = calculate_stones_count(75)

puts "Камней: #{total_stones}"