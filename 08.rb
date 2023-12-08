input = File.read('08.input').split("\n").map(&:strip)

# problem 1

instructions = nil
map = {}

input.each do |line|
  if instructions.nil?
    instructions = line.split('')
    next
  end

  node, lr = line.split(' = ')
  if node
    left, right = lr.split(', ').map { |s| s.sub('(', '').sub(')', '') }
    map[node] = [left, right]
  end
end

steps = 0
inst_idx = 0
curr_node = 'AAA'

while curr_node != 'ZZZ'
  instruction = instructions[inst_idx]
  if instruction.nil?
    inst_idx = 0
    instruction = instructions[inst_idx]
  end

  curr_node = instruction === 'L' ? map[curr_node][0] : map[curr_node][1]
  inst_idx += 1
  steps += 1
end

puts steps

# problem 2

instructions = nil
map = {}

input.each do |line|
  if instructions.nil?
    instructions = line.split('')
    next
  end

  node, lr = line.split(' = ')
  if node
    left, right = lr.split(', ').map { |s| s.sub('(', '').sub(')', '') }
    map[node] = [left, right]
  end
end

steps = 0
inst_idx = 0
curr_nodes = map.keys.select { |v| v.end_with?('A') }
curr_nodes_loop = {}

br = false

while !br
  new_curr_nodes = []
  instruction = instructions[inst_idx]
  if instruction.nil?
    inst_idx = 0
    instruction = instructions[inst_idx]
  end

  curr_nodes.each.with_index do |curr_node, idx|
    new_curr = instruction === 'L' ? map[curr_node][0] : map[curr_node][1]
    new_curr_nodes.push(new_curr)

    if new_curr.end_with?('Z') && curr_nodes_loop[idx].nil?
      curr_nodes_loop[idx] = steps + 1
      if curr_nodes_loop.keys.count === curr_nodes.count
        br = true
      end
    end
  end

  curr_nodes = new_curr_nodes

  inst_idx += 1
  steps += 1
end

def lcm(values)
  val = 1
  values.each do |v|
    val = val.lcm(v)
  end
  val
end

puts lcm(curr_nodes_loop.values.uniq)
