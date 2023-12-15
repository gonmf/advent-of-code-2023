input = File.read('15.input').split("\n").map(&:strip)

# problem 1

def hash(str)
  curr = 0

  str.chars.each do |c|
    curr = ((curr + c.ord) * 17) % 256
  end

  curr
end

# p hash('HASH')

p input[0].split(',').map { |s| hash(s) }.sum

# problem 2

boxes = Array.new(256).map { |v, i| [] }

input[0].split(',').each do |oper|
  if oper.include?('=')
    op = '='
    label, number = oper.split('=')
  elsif oper.include?('-')
    op = '-'
    label, = oper.split('-')
  end

  box_number = hash(label)

  box = boxes[box_number]

  if op == '='
    bv = box.find { |v| v[0] == label }
    if bv
      bv[1] = number
    else
      box.push([label, number])
    end
  elsif op == '-'
    if box.any? { |v| v[0] == label }
      boxes[box_number] = box.select { |v| v[0] != label }
    end
  end
end

focusing_power = 0

boxes.each.with_index do |bvs, box_nr|
  bvs.each.with_index do |bv, slot_nr|
    focal_length = bv[1].to_i
    focusing_power += (box_nr + 1) * (slot_nr + 1) * focal_length
  end
end

p focusing_power
