require './reader.rb'

TIMES = ARGV.first.to_i

class WarehouseWoe

  attr_accessor :map, :moves, :robot_position, :visited, :size, :size_x, :size_y, :moves_size

  DIRECTIONS = [
    TOP = '^',
    RIGHT = '>',
    BOTTOM = 'v',
    LEFT = '<',
  ]

  ROBOT = '@'
  BORDER = '#'
  BOX = 'O'
  FREE_CELL = '.'

  def initialize
    @map = []
    @moves = []
    @robot_position = []
    @visited = {}
  end

  def fill_map(file)
    Reader.call(file) do |line|
      line_charts = line.strip.chars
      robot_position = line_charts.detect { _1 == ROBOT }
      map << line_charts
      @robot_position = [map.size - 1, line_charts.index(robot_position)] if robot_position
    end
  end

  def fill_moves(file)
    Reader.call(file) do |line|
      @moves << line.strip
    end
    @moves = @moves.join.chars
  end

  def determine_sizes
    @size_x = @map.size
    @size_y = @map[0].size
    @size = "#{@size_x}x#{@size_y}"
    @moves_size = @moves.size
  end

  def start
    @times = 0
    moves.each do |move|
      current_x, current_y = robot_position
      next_x, next_y = cell(current_x, current_y, move)
      value = map[next_x][next_y]
      case value
      when BORDER
      when FREE_CELL
        map[current_x][current_y] = FREE_CELL
        map[next_x][next_y] = ROBOT
        @robot_position = [next_x, next_y]
      when BOX
        shift = bfs([next_x, next_y], move)
        if shift
          map[current_x][current_y] = FREE_CELL
          map[next_x][next_y] = ROBOT
          @robot_position = [next_x, next_y]
        end
      end
      @times += 1
      draw_map(move)
    end
  end

  def coordinates
    sum = 0
    size_x.times do |x|
      size_y.times do |y|
        if map[x][y] == BOX
          sum += (100 * x + y)
        end
      end
    end
    sum
  end

  def bfs(point, move)
    queue = []
    queue << point
    shift = false
    while queue.size != 0
      box_x, box_y = queue.shift

      x, y = cell(box_x, box_y, move)
      value = map[x][y]
      case value
      when BORDER
      when FREE_CELL
        map[x][y] = BOX
        shift = true
      when BOX
        queue.push([x, y])
      end
    end
    shift
  end

  def draw_map(move)
    if TIMES.zero? || @times == TIMES
      puts "MOVE: #{move}"
      map.each do |line|
        puts line.inspect
      end
      puts "ROBOT POSITION: #{robot_position}"
    end
  end

  def cell(x, y, direction)
    case direction
    when TOP
      x -= 1
    when RIGHT
      y += 1
    when BOTTOM
      x += 1
    when LEFT
      y -= 1
    else
      raise "Unknown direction: #{direction.inspect}"
    end

    [x, y]
  end

end

warehouse_woe = WarehouseWoe.new
warehouse_woe.fill_map('map-2.txt')
warehouse_woe.fill_moves('moves-2.txt')
warehouse_woe.determine_sizes

puts "Warehouse woe size: #{warehouse_woe.size} | moves size: #{warehouse_woe.moves_size} | robot position: #{warehouse_woe.robot_position}"

warehouse_woe.start
puts "Coordinates: #{warehouse_woe.coordinates}"
