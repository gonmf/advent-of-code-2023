input = File.read('17.input').split("\n").map(&:strip)

# problem 1

def search(map, minimum_steps, variable_steps)
  to_search = []
  to_search.push([[0, 0], 'v', 0, 1])
  to_search.push([[0, 0], 'h', 0, 1])
  memo = {}
  dirs = nil
  step = 0

  while to_search.any?
    step += 1
    to_search = to_search.sort_by { |v| v[3] } if (step % 512) == 0
    this_search = to_search.shift

    pos, dir, heat_loss, = this_search
    pos_y, pos_x = pos

    memo_key = [pos_y, pos_x, dir].join(',')
    next if memo[memo_key] && memo[memo_key] <= heat_loss
    memo[memo_key] = heat_loss

    if pos_y == map.count - 1 && pos_x == map[0].count - 1
      return heat_loss
    end

    if dir == 'v'
      dirs = [[1, 0], [-1, 0]].shuffle
    else
      dirs = [[0, 1], [0, -1]].shuffle
    end

    new_dir = dir == 'v' ? 'h' : 'v'

    dirs.each do |this_dir|
      dir_y, dir_x = this_dir

      new_ps_y = pos_y + dir_y * minimum_steps
      new_ps_x = pos_x + dir_x * minimum_steps
      next if new_ps_y < 0 || new_ps_y >= map.count || new_ps_x < 0 || new_ps_x >= map[0].count

      new_ht_loss = heat_loss
      (1..minimum_steps).each do |step|
        new_ht_loss += map[pos_y + dir_y * step][pos_x + dir_x * step]
      end

      this_ht_loss = new_ht_loss

      (1..variable_steps).each do |num|
        this_ps_y = new_ps_y + dir_y * num
        this_ps_x = new_ps_x + dir_x * num
        next if this_ps_y < 0 || this_ps_y >= map.count || this_ps_x < 0 || this_ps_x >= map[0].count

        if num > 0
          this_ht_loss += map[new_ps_y + dir_y * num][new_ps_x + dir_x * num]
        end

        memo_key = [this_ps_y, this_ps_x, new_dir].join(',')

        memo_val = memo[memo_key]
        if memo_val.nil? || memo_val > this_ht_loss
          score = this_ht_loss - this_ps_y - this_ps_x
          to_search.push([[this_ps_y, this_ps_x], new_dir, this_ht_loss, score])
        end
      end
    end
  end
end

map = input.map { |l| l.chars.map(&:to_i) }

p search(map, 0, 3)

# problem 2

map = input.map { |l| l.chars.map(&:to_i) }

p search(map, 3, 7)
