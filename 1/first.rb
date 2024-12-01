require './reader.rb'

def calculate_total_distance(left_list, right_list)
  # sort two arrays for feature comparing by indexes
  left_list_sorted = left_list.sort
  right_list_sorted = right_list.sort

  total_distance = 0
  left_list_sorted.each_with_index do |left, index|
    total_distance += (left - right_list_sorted[index]).abs
  end
  total_distance
end

left_list, right_list = Reader.call('input.txt')
total_distance = calculate_total_distance(left_list, right_list)
puts "Result: #{total_distance}"