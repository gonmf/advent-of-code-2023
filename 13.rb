input = File.read('13.input').split("\n").map(&:strip)

# problem 1

patterns = []
curr_pattern = []

input.each do |line|
  if line.size == 0
    patterns.push(curr_pattern) if curr_pattern.any?
    curr_pattern = []
  else
    curr_pattern.push(line.chars)
  end
end

patterns.push(curr_pattern) if curr_pattern.any?

def pattern_check(pattern, ignore_pos = nil)
  (0..(pattern[0].count - 2)).each do |x|
    next if ignore_pos && ignore_pos[2] == "h#{x}"

    mirrored = true

    (0..(pattern[0].count / 2)).each do |x_offset|
      x1 = x - x_offset
      x2 = x + 1 + x_offset

      pattern.each do |line|
        if x1 >= 0 && x2 < pattern[0].count && line[x1] != line[x2]
          mirrored = false
          break
        end
      end
    end

    if mirrored
      return [0, x + 1, "h#{x}"]
    end
  end

  (0..(pattern.count - 2)).each do |y|
    next if ignore_pos && ignore_pos[2] == "v#{y}"

    mirrored = true

    (0..(pattern.count / 2)).each do |y_offset|
      y1 = y - y_offset
      y2 = y + 1 + y_offset

      if y1 >= 0 && y2 < pattern.count && pattern[y1] != pattern[y2]
        mirrored = false
        break
      end
    end

    if mirrored
      return [y + 1, 0, "v#{y}"]
    end
  end

  nil
end

total_nr_columns_to_left = 0
total_nr_columns_above = 0

patterns.each.with_index do |pattern, idx|
  res = pattern_check(pattern)

  y_change, x_change = res
  total_nr_columns_above += y_change
  total_nr_columns_to_left += x_change
end

p total_nr_columns_to_left + total_nr_columns_above * 100

# problem 2

total_nr_columns_to_left = 0
total_nr_columns_above = 0

patterns.each.with_index do |pattern, idx|
  found = false

  old_valid = pattern_check(pattern)

  pattern.each.with_index do |line, y|
    line.each.with_index do |v, x|
      pattern[y][x] = pattern[y][x] == '.' ? '#' : '.'
      res = pattern_check(pattern, old_valid)
      pattern[y][x] = pattern[y][x] == '.' ? '#' : '.'

      if res
        y_change, x_change, = res
        total_nr_columns_above += y_change
        total_nr_columns_to_left += x_change
        found = true
        break
      end
    end

    break if found
  end
end

p total_nr_columns_to_left + total_nr_columns_above * 100
