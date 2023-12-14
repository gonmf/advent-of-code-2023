input = File.read('14.input').split("\n").map(&:strip)

# problem 1

dish = input.map { |line| line.chars }

def tilt_north(dish)
  total = 0

  dish.each.with_index do |line, y|
    line.each.with_index do |v, x|
      next unless v == 'O'

      this_y = y
      while this_y > 0 && dish[this_y - 1][x] == '.'
        dish[this_y][x] = '.'
        this_y = this_y - 1
        dish[this_y][x] = 'O'
      end

      total += dish.count - this_y
    end
  end

  total
end

p tilt_north(dish)

# problem 2

def tilt_south(dish)
  total = 0

  dish.each.with_index do |line, y|
    y = dish.count - y - 1
    line = dish[y]
    line.each.with_index do |v, x|
      next unless v == 'O'

      this_y = y
      while this_y < dish.count - 1 && dish[this_y + 1][x] == '.'
        dish[this_y][x] = '.'
        this_y = this_y + 1
        dish[this_y][x] = 'O'
      end

      total += dish.count - this_y
    end
  end

  total
end

def tilt_west(dish)
  total = 0

  dish.each.with_index do |line, y|
    line.each.with_index do |v, x|
      next unless v == 'O'

      this_x = x
      while this_x > 0 && dish[y][this_x - 1] == '.'
        dish[y][this_x] = '.'
        this_x = this_x - 1
        dish[y][this_x] = 'O'
      end

      total += dish.count - y
    end
  end

  total
end

def tilt_east(dish)
  total = 0

  dish.each.with_index do |line, y|
    line.each.with_index do |v, x|
      x = line.count - x - 1
      next unless dish[y][x] == 'O'

      this_x = x
      while this_x < line.count - 1 && dish[y][this_x + 1] == '.'
        dish[y][this_x] = '.'
        this_x = this_x + 1
        dish[y][this_x] = 'O'
      end

      total += dish.count - y
    end
  end

  total
end

def cycle(dish)
  tilt_north(dish)
  tilt_west(dish)
  tilt_south(dish)
  tilt_east(dish)
end

def dish_hash(dish)
  dish.flatten.join
end

dish = input.map { |line| line.chars }

repeats = {}
repeats[dish_hash(dish)] = 0

(1..1000000000).each do |cycle_i|
  cycle(dish)

  this_hash = dish_hash(dish)

  if !repeats[dish_hash(dish)].nil?
    cycle_length = cycle_i - repeats[dish_hash(dish)]
    cycle_i += ((1000000000 - cycle_i) / cycle_length) * cycle_length

    total = 0
    while cycle_i < 1000000000
      total = cycle(dish)
      cycle_i += 1
    end
    p total
    exit
  else
    repeats[dish_hash(dish)] = cycle_i
  end
end
