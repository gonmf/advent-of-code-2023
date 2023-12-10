input = File.read('10.input').split("\n").map(&:strip)

# problem 1

tiles = input.map { |l| l.chars }
distances = tiles.map { |l| l.map { nil } }

@directions = {
  '|' => [[1, 0], [-1, 0]],
  '-' => [[0, 1], [0, -1]],
  'L' => [[-1, 0], [0, 1]],
  'J' => [[-1, 0], [0, -1]],
  '7' => [[1, 0], [0, -1]],
  'F' => [[1, 0], [0, 1]],
  'S' => nil
}

def mark_distance(tiles, distances, y, x, curr_dst, curr_loop)
  return if y < 0 || x < 0 || y >= tiles.count || x > tiles[0].count
  return if distances[y][x] && distances[y][x] <= curr_dst

  distances[y][x] = curr_dst
  curr_dst += 1

  dirs = @directions[tiles[y][x]]

  if dirs.nil?
    dirs = []
    [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dir1|
      y_shift, x_shift = dir1
      @directions[tiles[y + y_shift][x + x_shift]]&.each do |dir2|
        y_shift2, x_shift2 = dir2

        if y_shift * -1 == y_shift2 && x_shift * -1 == x_shift2
          dirs.push(dir1)
        end
      end
    end
  end

  dirs.each do |dir|
    y_shift, x_shift = dir

    curr_loop.push([y + y_shift, x + x_shift, curr_dst])
  end
end

curr_loop = []

tiles.each.with_index do |l, y|
  l.each.with_index do |v, x|
    if v == 'S'
      curr_loop.push([y, x, 0])
      break
    end
  end
end

while curr_loop.count > 0
  currl = curr_loop.shift
  mark_distance(tiles, distances, currl[0], currl[1], currl[2], curr_loop)
end

p distances.map { |l| l.compact.max }.compact.max

# problem 2

@large_tiles = {
  '|' => [[0, 0], [1, 0], [-1, 0]],
  '-' => [[0, 0], [0, 1], [0, -1]],
  'L' => [[0, 0], [-1, 0], [0, 1]],
  'J' => [[0, 0], [-1, 0], [0, -1]],
  '7' => [[0, 0], [1, 0], [0, -1]],
  'F' => [[0, 0], [1, 0], [0, 1]],
  'S' => [[0, 0], [1, 0], [0, 1], [-1, 0], [0, -1]],
  '.' => []
}

def expand_map(tl)
  tl.flat_map do |l|
    l = l.flat_map { |v| [v, v, v] }
    [l.clone, l.clone, l]
  end
end

def build_tile_pipe_expanded(tiles, distances2)
  tiles.each.with_index do |l, li|
    l.each.with_index do |v, ri|
      next if distances2[li * 3 + 1][ri * 3 + 1].nil?

      @large_tiles[v].each do |large_tile|
        y_offset, x_offset = large_tile

        y = li * 3 + 1 + y_offset
        x = ri * 3 + 1 + x_offset

        distances2[y][x] = '@'
      end
    end
  end
end

distances2 = expand_map(distances)

build_tile_pipe_expanded(tiles, distances2)

def fill_map(flood_map, y, x, num, outcomes, to_fill_map)
  if y < 0 || x < 0 || y >= flood_map.count || x >= flood_map[0].count
    outcomes[num] = '@'
    return
  end

  if flood_map[y][x].nil?
    flood_map[y][x] = num
    to_fill_map.unshift([y, x - 1, num])
    to_fill_map.unshift([y, x + 1, num])
    to_fill_map.unshift([y - 1, x, num])
    to_fill_map.unshift([y + 1, x, num])
  end
end

flood_map = distances2.map { |l| l.map { |v| v == '@' ? '@' : nil } }
outcomes = {}
flood_map_i = 0
to_fill_map = []

distances2.each.with_index do |l, li|
  l.each.with_index do |v, ri|
    if v != '@'
      to_fill_map.push([li, ri, flood_map_i])
      flood_map_i += 1
    end
  end
end

while to_fill_map.count > 0
  to_fill = to_fill_map.shift
  li, ri, num = to_fill

  fill_map(flood_map, li, ri, num, outcomes, to_fill_map)
end

total = 0

distances.each.with_index do |l, y|
  l.each.with_index do |v, x|
    y2 = y * 3 + 1
    x2 = x * 3 + 1

    if flood_map[y2][x2] != '@' && outcomes[flood_map[y2][x2]] != '@'
      total += 1
    end
  end
end

p total
