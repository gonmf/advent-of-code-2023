input = File.read('03.input').split("\n").map(&:strip)

# problem 1

matrix = input.map { |l| l.chars }
lightned = matrix.map { |l| l.map { |r| false } }

height = matrix.count
width = matrix[0].count

def is_number(matrix, w, h)
  return if w < 0 || h < 0 || w >= matrix[0].count || h >= matrix.count

  c = matrix[h][w]

  c == '0' || c.to_i > 0
end

def is_symbol(matrix, w, h)
  return if w < 0 || h < 0 || w >= matrix[0].count || h >= matrix.count

  c = matrix[h][w]

  c != '.' && !is_number(matrix, w, h)
end

def mark_numbers(matrix, w, h, lightned)
  if !lightned[h][w] && is_number(matrix, w, h)
    lightned[h][w] = true
    mark_numbers(matrix, w - 1, h, lightned)
    mark_numbers(matrix, w + 1, h, lightned)
  end
end

gears_neigh_count = matrix.map { |l| l.map { |r| 0 } }

(0...height).each do |h|
  (0...width).each do |w|
    next if lightned[h][w]

    if is_number(matrix, w, h)
      if is_symbol(matrix, w - 1, h) || is_symbol(matrix, w + 1, h) || is_symbol(matrix, w, h - 1) || is_symbol(matrix, w, h + 1) ||
         is_symbol(matrix, w - 1, h - 1) || is_symbol(matrix, w + 1, h - 1) || is_symbol(matrix, w - 1, h + 1) || is_symbol(matrix, w + 1, h + 1)
        mark_numbers(matrix, w, h, lightned)

        # numbers[num] = 1
      end
    end
  end
end

numbers = []
part_ids = matrix.map { |l| l.map { |r| nil } }
part_id = 1
part_id_to_num = {}

num = ''
lightned.each.with_index do |line, y|
  line.each.with_index do |c, x|
    if c
      num = num + matrix[y][x]
      part_ids[y][x] = part_id
    else
      if num.size > 0
        numbers.push(num)
        part_id_to_num[part_id] = num
        num = ''
        part_id = part_id + 1
      end
    end
  end

  if num.size > 0
    numbers.push(num)
    part_id_to_num[part_id] = num
    num = ''
    part_id = part_id + 1
  end
end

puts numbers.map(&:to_i).sum

# problem 2

total = 0

(0...height).each do |h|
  (0...width).each do |w|
    next unless matrix[h][w] == '*'

    nids = [
      part_ids[h][w - 1],
      part_ids[h][w + 1],
      part_ids[h - 1][w - 1],
      part_ids[h - 1][w + 1],
      part_ids[h + 1][w - 1],
      part_ids[h + 1][w + 1],
      part_ids[h - 1][w],
      part_ids[h + 1][w],
    ]

    nids = nids.compact.uniq.map { |n| part_id_to_num[n] }
    if nids.count == 2
      total += nids[0].to_i * nids[1].to_i
    end
  end
end

puts total
