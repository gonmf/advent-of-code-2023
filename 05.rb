input = File.read('05.input').split("\n").map(&:strip)

# problem 1

seeds_to_plant = []
mappers = []

input.each do |line|
  if line.start_with?('seeds: ')
    seeds_to_plant = line.split(': ')[1].split(' ').map(&:to_i)
    next
  end

  if line.end_with?(' map:')
    mappers.push([])
    next
  end

  if line.split(' ').size == 3
    mappers.last.push(line.split(' ').map(&:to_i))
    next
  end
end

min_location = nil

seeds_to_plant.each do |seed|

  mappers.each do |mapper|
    mapper.each do |map|
      to, from, len = map

      if from <= seed && seed <= from + len
        seed += to - from
        break
      end
    end
  end

  min_location = min_location.nil? ? seed : [min_location, seed].min
end

puts min_location

# problem 2

seeds_to_plant = []
mappers = []

input.each do |line|
  if line.start_with?('seeds: ')
    seeds_to_plant = line.split(': ')[1].split(' ').map(&:to_i)
    next
  end

  if line.end_with?(' map:')
    mappers.push([])
    next
  end

  if line.split(' ').size == 3
    mappers.last.push(line.split(' ').map(&:to_i))
    next
  end
end

seeds = []
seeds_to_plant.each_slice(2) do |seed_pair|
  seeds.push([seed_pair[0], seed_pair[0] + seed_pair[1] - 1])
end

def intersect_range(a_start, a_end, b_start, b_end)
  start = [a_start, b_start].max
  nlen = [a_end, b_end].min

  [start, nlen] if start <= nlen
end

def unite_ranges(seeds)
  seeds.each.with_index do |seed1, idx1|
    seeds.each.with_index do |seed2, idx2|
      next if idx1 == idx1

      if intersect_range(seed1[0], seed1[1], seed2[0], seed2[1])
        seed1[0] = seed2[0] = [seed1[0], seed1[0]].min
        seed1[1] = seed2[1] = [seed1[1], seed1[1]].max
      end
    end
  end

  seeds.uniq.sort_by { |s| s[0] }
end

mappers.each do |mapper|
  new_seeds = []

  while seeds.size > 0
    seed = seeds.shift
    any_matched = false

    mapper.each do |map|
      seed_start, seed_end = seed
      to, from_start, len = map
      from_end = from_start + len - 1
        shift = to - from_start

      intersected_seed = intersect_range(seed_start, seed_end, from_start, from_end)
      if !intersected_seed.nil?
        any_matched = true
        int_start, int_end = intersected_seed

        if int_start > seed_start
          seeds.push([seed_start, int_start - 1])
        end
        if int_end < seed_end
          seeds.push([int_end + 1, seed_end])
        end

        final = [int_start + shift, int_end + shift]
        new_seeds.push(final)
        break
      end
    end

    new_seeds.push(seed) if !any_matched
  end

  seeds = new_seeds

  unite_ranges(seeds)
end

p seeds.map(&:first).min
