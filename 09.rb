input = File.read('09.input').split("\n").map(&:strip)

# problem 1

total = 0

input.each do |line|
  seq = line.split(' ').map(&:to_i)
  seq_last = seq.last
  sum_last = 0

  while seq.any? { |v| v != 0 }
    seq = seq.map.with_index { |v, idx| idx > 0 ? v - seq[idx - 1] : nil }
    seq.shift
    sum_last += seq.last
  end

  total += sum_last + seq_last
end

p total

# problem 2

total = 0

input.each do |line|
  seq = line.split(' ').map(&:to_i)
  all_firsts = []

  while seq.any? { |v| v != 0 }
    all_firsts.push(seq.first)
    seq = seq.map.with_index { |v, idx| idx > 0 ? v - seq[idx - 1] : nil }
    seq.shift
  end

  subtotal = 0
  all_firsts.reverse.each do |v|
    subtotal = v - subtotal
  end
  total += subtotal
end

p total
