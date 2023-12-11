input = File.read('11.input').split("\n").map(&:strip)

# problem 1

map = input.map { |l| l.chars }

empty_rows = []
empty_cols = []

map.each.with_index do |l, li|
  if l.all? { |v| v == '.' }
    empty_rows.push(li)
  end
end

map[0].each.with_index do |r, ri|
  if (0...map.count).all? { |y| map[y][ri] == '.' }
    empty_cols.push(ri)
  end
end

stars = []

map.each.with_index do |l, li|
  l.each.with_index do |v, ri|
    if v != '.'
      stars.push([li, ri, li, ri])
    end
  end
end

stars.each do |star|
  li, ri = star

  empty_cols.each do |col_num|
    if col_num < ri
      star[3] += 1
    end
  end

  empty_rows.each do |row_num|
    if row_num < li
      star[2] += 1
    end
  end
end

def calc_distance(star1, star2)
  (star1[2] - star2[2]).abs + (star1[3] - star2[3]).abs
end

def calc_sum_of_distances(stars, star_idx)
  sum = 0
  return sum if star_idx == stars.count

  ((star_idx + 1)...stars.count).each do |idx|
    dst = calc_distance(stars[star_idx], stars[idx])

    sum += dst
  end

  sum + calc_sum_of_distances(stars, star_idx + 1)
end

p calc_sum_of_distances(stars, 0)

# problem 2

stars.each do |star|
  li, ri = star
  star[2] = li
  star[3] = ri

  empty_cols.each do |col_num|
    if col_num < ri
      star[3] += 999999
    end
  end

  empty_rows.each do |row_num|
    if row_num < li
      star[2] += 999999
    end
  end
end

p calc_sum_of_distances(stars, 0)

