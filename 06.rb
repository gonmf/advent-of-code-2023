input = File.read('06.input').split("\n").map(&:strip)

# problem 1

_, *times = input[0].split(' ')
_, *distances = input[1].split(' ')

times = times.map(&:to_i)
distances = distances.map(&:to_i)

multiplied_ways_to_beat = 1

distances.each.with_index do |distance, idx|
  time = times[idx]

  ways_to_beat = 0

  (1...time).each do |push_time|
    this_dst = (time - push_time) * push_time

    ways_to_beat += 1 if this_dst > distance
  end

  multiplied_ways_to_beat *= ways_to_beat
end

p multiplied_ways_to_beat

# problem 2

time = times.map(&:to_s).join.to_i
distance = distances.map(&:to_s).join.to_i

ways_to_beat = 0

(1...time).each do |push_time|
  this_dst = (time - push_time) * push_time

  if this_dst > distance
    ways_to_beat += 1
  end

end

p ways_to_beat
