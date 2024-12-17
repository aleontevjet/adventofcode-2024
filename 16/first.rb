require './reader.rb'

class MazeSolver
  DIRECTIONS = [[0, 1, '>'], [1, 0, 'v'], [0, -1, '<'], [-1, 0, '^']]  # Направления с символами стрелок
  TURN_COST = 1000  # Стоимость поворота
  MOVE_COST = 1     # Стоимость прямого движения

  def initialize(maze)
    @maze = maze
    @rows = maze.length
    @cols = maze[0].length
  end

  def find_start_and_end
    start = nil
    finish = nil
    @maze.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        if cell == 'S'
          start = [r, c]
        elsif cell == 'E'
          finish = [r, c]
        end
      end
    end
    [start, finish]
  end

  def cheapest_path(start, finish)
    # Начинаем с направления "восток" (направо)
    queue = [[start, 0, 0]]  # Очередь с приоритетами (позиция, направление, стоимость)
    visited = Array.new(@rows) { Array.new(@cols, Float::INFINITY) }
    visited[start[0]][start[1]] = 0
    parent = {}  # Словарь для восстановления пути

    while queue.any?
      current, prev_direction, current_cost = queue.shift

      r, c = current

      return reconstruct_path(parent, start, finish, visited) if current == finish

      DIRECTIONS.each_with_index do |(dr, dc, direction), idx|
        nr, nc = r + dr, c + dc
        if valid_move?(nr, nc)
          # Рассчитываем стоимость текущего шага
          new_cost = if prev_direction != idx
                       current_cost + TURN_COST + MOVE_COST  # Поворот
                     else
                       current_cost + MOVE_COST  # Прямой шаг
                     end

          if new_cost < visited[nr][nc]
            visited[nr][nc] = new_cost
            parent[[nr, nc]] = [r, c, idx]
            queue.push([[nr, nc], idx, new_cost])
            queue.sort_by! { |_, _, cost| cost }  # Сортируем очередь по стоимости
          end
        end
      end
    end

    nil  # Путь не найден
  end

  private

  def valid_move?(r, c)
    r >= 0 && r < @rows && c >= 0 && c < @cols && @maze[r][c] != '#'
  end

  def reconstruct_path(parent, start, finish, visited)
    current = finish
    path = []

    while current != start
      r, c = current
      prev_r, prev_c, direction = parent[current]
      @maze[prev_r][prev_c] = DIRECTIONS[direction][2]  # Помечаем клетку стрелкой
      current = [prev_r, prev_c]
      path.unshift([prev_r, prev_c])  # Восстанавливаем путь
    end

    # Помечаем стартовую точку
    @maze[start[0]][start[1]] = 'S'
    path.unshift(start)
    puts "Общая стоимость пути (с учетом поворотов): #{visited[finish[0]][finish[1]]}"
    path
  end
end

# Пример лабиринта
maze = []; Reader.call('maze-3.txt') { |line| maze << line }; maze = maze.map(&:chars)

solver = MazeSolver.new(maze)
start, finish = solver.find_start_and_end

if start && finish
  path = solver.cheapest_path(start, finish)
  if path
    puts "Самый дешевый путь найден!"
    # Выводим лабиринт с помеченным путем
    maze.each { |row| puts row.join('') }
  else
    puts "Путь не найден"
  end
else
  puts "Не найдены точки старта или финиша"
end


#
#
# maze = []; Reader.call('maze-1.txt') { |line| maze << line }; maze = maze.map(&:chars)
#
# # Преобразуем лабиринт в массив, где каждая строка — это массив символов
# maze = maze.map(&:chars)
#
# puts "initial maze:"
# maze.each { |row| puts row.join }
# puts "======================================="