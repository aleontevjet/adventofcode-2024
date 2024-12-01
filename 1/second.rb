require './reader.rb'

def calculate_similarity_score(left_list, right_list)
  # group numbers
  right_count = right_list.tally
  left_list.sum { |number| number * right_count[number].to_i }
end


left_list, right_list = Reader.call('input.txt')
similarity_score = calculate_similarity_score(left_list, right_list)

puts "Result: #{similarity_score}"