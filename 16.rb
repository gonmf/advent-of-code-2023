input = File.read('16.input').split("\n").map(&:strip)

# problem 1

def calculate_energized(map, start_beam)
  beams = [start_beam]
  energized = map.map { |l| l.map { false } }
  unique_energized_dirs = {}
  any_new_reflected = true

  while beams.any? && any_new_reflected
    any_new_reflected = false

    new_beams = []

    beams.each do |beam|
      beam_key = beam.flatten.join(',')
      if unique_energized_dirs[beam_key]
        next
      else
        unique_energized_dirs[beam_key] = true
        any_new_reflected = true
      end

      beam_dir, beam_pos = beam
      beam_dir_y, beam_dir_x = beam_dir
      beam_pos_y, beam_pos_x = beam_pos

      beam_pos_y += beam_dir_y
      beam_pos_x += beam_dir_x

      if beam_pos_y < 0 || beam_pos_y == map.count || beam_pos_x < 0 || beam_pos_x == map[0].count
        next
      end

      energized[beam_pos_y][beam_pos_x] = true

      c = map[beam_pos_y][beam_pos_x]

      if c == '.'
        new_beams.push([[beam_dir_y, beam_dir_x], [beam_pos_y, beam_pos_x]])
        next
      end

      if c == '/'
        prev_beam_dir_y = beam_dir_y
        beam_dir_y = -beam_dir_x
        beam_dir_x = -prev_beam_dir_y
        new_beams.push([[beam_dir_y, beam_dir_x], [beam_pos_y, beam_pos_x]])
        next
      end

      if c == '\\'
        prev_beam_dir_y = beam_dir_y
        beam_dir_y = beam_dir_x
        beam_dir_x = prev_beam_dir_y
        new_beams.push([[beam_dir_y, beam_dir_x], [beam_pos_y, beam_pos_x]])
        next
      end

      if (c == '|' && beam_dir_x == 0) || (c == '-' && beam_dir_y == 0)
        new_beams.push([[beam_dir_y, beam_dir_x], [beam_pos_y, beam_pos_x]])
        next
      end

      if c == '-'
        new_beams.push([[0, -1], [beam_pos_y, beam_pos_x]])
        new_beams.push([[0, 1], [beam_pos_y, beam_pos_x]])
        next
      end

      if c == '|'
        new_beams.push([[-1, 0], [beam_pos_y, beam_pos_x]])
        new_beams.push([[1, 0], [beam_pos_y, beam_pos_x]])
        next
      end
    end

    beams = new_beams
  end

  energized.sum { |l| l.count { |v| v } }
end

p calculate_energized(input.map { |l| l.chars }, [[0, 1], [0, -1]])

# problem 2

most_energized = 0

input.each.with_index do |line, y|
  most_energized = [most_energized, calculate_energized(input.map { |l| l.chars }, [[0, 1], [y, -1]])].max
  most_energized = [most_energized, calculate_energized(input.map { |l| l.chars }, [[0, -1], [y, line.chars.count]])].max
end

input[0].chars.each.with_index do |c, x|
  most_energized = [most_energized, calculate_energized(input.map { |l| l.chars }, [[1, 0], [-1, x]])].max
  most_energized = [most_energized, calculate_energized(input.map { |l| l.chars }, [[-1, 0], [input.count, x]])].max
end

p most_energized
