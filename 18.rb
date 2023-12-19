input = File.read('18.input').split("\n").map(&:strip)

# problem 1

dirs = {
  'U' => [-1, 0],
  'D' => [1, 0],
  'L' => [0, -1],
  'R' => [0, 1]
}

vertices = []
curr = [0, 0]
vertices.push(curr)
perimeter = 0

input.each do |line|
  dir, steps, = line.split(' ')
  steps = steps.to_i
  perimeter += steps

  change_y, change_x = dirs[dir]
  change_y *= steps
  change_x *= steps

  curr_y, curr_x = curr

  curr = [curr_y + change_y, curr_x + change_x]
  vertices.push(curr)
end

def calc(vertices, perimeter)
  sum = 0

  (0...vertices.count).each do |idx|
    v0 = idx
    v1 = (idx + 1) % vertices.count

    v0_y, v0_x = vertices[v0]
    v1_y, v1_x = vertices[v1]

    sum += v0_x * v1_y - v1_x * v0_y
  end

  sum / 2 + perimeter / 2 + 1
end

p calc(vertices, perimeter)

# problem 2

dirs = {
  '3' => [-1, 0],
  '1' => [1, 0],
  '2' => [0, -1],
  '0' => [0, 1]
}

vertices = []
curr = [0, 0]
vertices.push(curr)
perimeter = 0

input.each do |line|
  _, _, rgb = line.split(' ')
  rgb = rgb.tr('()#', '')

  dir = rgb.chars.last
  steps = rgb = rgb.chars[0...(rgb.size - 1)].join.to_i(16)

  perimeter += steps

  change_y, change_x = dirs[dir]
  change_y *= steps
  change_x *= steps

  curr_y, curr_x = curr

  curr = [curr_y + change_y, curr_x + change_x]
  vertices.push(curr)
end

p calc(vertices, perimeter)
