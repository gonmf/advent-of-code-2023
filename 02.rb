input = File.read('02.input').split("\n").map(&:strip)

# problem 1

goal = { red: 12, green: 13, blue: 14 }

possible_id_sum = 0

input.each do |line|
  game_id = line.split(': ')[0].split(' ')[1].to_i
  takes = line.split(': ')[1].split('; ')

  if takes.all? { |take| take.split(', ').all? { |t| goal[t.split(' ')[1].to_sym] >= t.split(' ')[0].to_i  } }
    possible_id_sum += game_id
  end
end

puts possible_id_sum

# problem 2

powers_sum = 0

input.each do |line|
  game_id = line.split(': ')[0].split(' ')[1].to_i
  takes = line.split(': ')[1].split('; ')

  min = { red: 0, green: 0, blue: 0 }

  takes.each do |take|
    take.split(', ').each do |t|
      color = t.split(' ')[1].to_sym
      val = t.split(' ')[0].to_i

      min[color] = [min[color], val].max
    end
  end

  power = min[:red] * min[:green] * min[:blue]
  powers_sum += power
end

puts powers_sum
