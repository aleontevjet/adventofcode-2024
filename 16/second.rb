class MazeSolver
  DIRECTIONS = [[0, 1, '>'], [1, 0, 'v'], [0, -1, '<'], [-1, 0, '^']]  # Направления с символами стрелок
  TURN_COST = 1001  # Стоимость поворота
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

  def find_all_paths(start, finish)
    # Очередь с приоритетами для обработки путей
    queue = [[start, nil, 0]]  # Стартовая позиция и направление
    visited = Array.new(@rows) { Array.new(@cols, Float::INFINITY) }
    visited[start[0]][start[1]] = 0
    parent = {}  # Для восстановления пути
    all_paths = []  # Список всех путей с минимальной стоимостью

    while queue.any?
      current, prev_direction, current_cost = queue.shift
      r, c = current

      # Если мы достигли финиша, то восстанавливаем путь и добавляем его в список путей
      if current == finish
        path = reconstruct_path(parent, start, finish)
        all_paths << path
        # После нахождения пути продолжаем искать все другие пути с одинаковой стоимостью
        next
      end

      DIRECTIONS.each_with_index do |(dr, dc, direction), idx|
        nr, nc = r + dr, c + dc
        if valid_move?(nr, nc)

          # Рассчитываем стоимость текущего шага
          new_cost = if prev_direction != idx
                       current_cost + TURN_COST  # Поворот
                     else
                       current_cost + MOVE_COST  # Прямой шаг
                     end

          # puts ">>>>>>"
          # puts visited.inspect
          # puts ">>>>>>"
          if new_cost < visited[nr][nc]
            visited[nr][nc] = new_cost
            parent[[nr, nc]] = [r, c, idx]
            queue.push([[nr, nc], idx, new_cost])
            queue.sort_by! { |_, _, cost| cost }  # Сортируем очередь по стоимости
          elsif (new_cost - TURN_COST) == visited[nr][nc]
            puts "r, c: #{[r, c].inspect}; nr, nc: #{[nc, nc.inspect].inspect} "
            puts "#{new_cost}; #{direction}".inspect
            # Если нашли путь с такой же стоимостью, добавляем его в очередь для поиска
            parent[[nr, nc]] = [r, c, idx]
            queue.push([[nr, nc], idx, new_cost])
          end
        end
      end

      # puts ">>>>>>"
      # @maze.each { |row| puts row.join('') }
      # puts ">>>>>>"
    end

    puts all_paths.flatten(1).uniq.size.inspect

    all_paths
  end

  private

  def valid_move?(r, c)
    r >= 0 && r < @rows && c >= 0 && c < @cols && @maze[r][c] != '#'
  end

  def reconstruct_path(parent, start, finish)
    current = finish
    path = []

    while current != start
      r, c = current
      prev_r, prev_c, direction = parent[current]
      @maze[prev_r][prev_c] = 'O'  # Заменяем стрелку на 'O' на пройденном пути
      current = [prev_r, prev_c]
      path.unshift([prev_r, prev_c])  # Восстанавливаем путь
    end

    # Помечаем стартовую точку
    @maze[start[0]][start[1]] = 'S'
    path.unshift(start)
    path
  end
end

# Пример лабиринта
maze = [
  "#################",
  "#...#...#...#..E#",
  "#.#.#.#.#.#.#.#.#",
  "#.#.#.#...#...#.#",
  "#.#.#.#.###.#.#.#",
  "#...#.#.#.....#.#",
  "#.#.#.#.#.#####.#",
  "#.#...#.#.#.....#",
  "#.#.#####.#.###.#",
  "#.#.#.......#...#",
  "#.#.###.#####.###",
  "#.#.#...#.....#.#",
  "#.#.#.#####.###.#",
  "#.#.#.........#.#",
  "#.#.#.#########.#",
  "#S#.............#",
  "#################"
]

# Преобразуем лабиринт в массив, где каждая строка — это массив символов
maze = maze.map(&:chars)

solver = MazeSolver.new(maze)
start, finish = solver.find_start_and_end

if start && finish
  paths = solver.find_all_paths(start, finish)
  if paths.any?
    puts "Все пути с минимальной стоимостью найдены!"
    # Выводим лабиринт с помеченным путем
    maze.each { |row| puts row.join('') }
  else
    puts "Путь не найден"
  end
else
  puts "Не найдены точки старта или финиша"
end