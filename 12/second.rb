require './reader.rb'

class Areas

  attr_accessor :map, :size, :visited, :size_x, :size_y

  DIRECTIONS = [
    TOP = :top,
    TOP_RIGHT = :top_right,
    RIGHT = :right,
    BOTTOM_RIGHT = :bottom_right,
    BOTTOM = :bottom,
    BOTTOM_LEFT = :bottom_left,
    LEFT = :left,
    TOP_LEFT = :top_left,
  ]

  def initialize(file)
    @map = Reader.call(file)
    @visited = {}
    @size_x = @map.size
    @size_y = @map[0].size
    @size = "#{@size_x}x#{@size_y}"
  end

  def calculate
    total = 0
    size_x.times do |x|
      size_y.times do |y|
        unless visited[[x, y]]
          square, perimeter = bfs([x, y])
          count = square * perimeter
          total += count
          puts "A region of #{map[x][y]} plants with price #{square} * #{perimeter} = #{count}."
        end
      end
    end
    total
  end

  def bfs(point)
    queue = []
    queue << point

    area = []
    area << [point.first, point.last]

    square = 1
    perimeter = 0

    visited[[point.first, point.last]] = true

    while queue.size != 0
      center_x, center_y = queue.shift

      points = neighborhoods(center_x, center_y)

      points.each do |(x, y)|
        unless visited[[x, y]]
          if !outside?(x, y) && !border?(x, y, center_x, center_y)
            square += 1
            queue.push([x, y])
            area << [x, y]
            visited[[x, y]] = true
          end
        end
      end
    end

    area.each do |(x, y)|
      neighborhoods(x, y).each do |(x1, y1)|
        if outside?(x1, y1) || border?(x1, y1, x, y)
          perimeter += 1
        end
      end
    end

    [square, perimeter]
  end

  def cell(x, y, direction)
    case direction
    when :top
      x -= 1
    when :top_right
      x -= 1
      y += 1
    when :right
      y += 1
    when :bottom_right
      x += 1
      y += 1
    when :bottom
      x += 1
    when :bottom_left
      x -= 1
      y += 1
    when :left
      y -= 1
    when :top_left
      x -= 1
      y -= 1
    else
      raise "Unknown direction: #{direction.inspect}"
    end

    [x, y]
  end

  def outside?(x, y)
    x.negative? || y.negative? || x >= size_x || y >= size_y
  end

  def border?(x, y, center_x, center_y)
    map[center_x][center_y] != map[x][y]
  end

  def diagonals(x, y)
    [TOP_RIGHT, BOTTOM_RIGHT, BOTTOM_LEFT, TOP_LEFT].map { |direction| cell(x, y, direction) }
  end

  def neighborhoods(x, y)
    [TOP, RIGHT, BOTTOM, LEFT].map { |direction| cell(x, y, direction) }
  end

end

area = Areas.new('input.txt')
puts "map size: #{area.size}"
total = area.calculate
puts "total: #{total}"