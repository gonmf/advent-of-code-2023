input = File.read('01.input').split("\n").map(&:strip)

# problem 1

cal_sum = 0

input.each do |line|
  nums = line.chars.filter { |c| c == '0' || c.to_i > 0 }

  cal = nums.first.to_i * 10 + nums.last.to_i

  cal_sum += cal
end

puts cal_sum

# problem 2

numbers = [
  ['one', 1],
  ['two', 2],
  ['three', 3],
  ['four', 4],
  ['five', 5],
  ['six', 6],
  ['seven', 7],
  ['eight', 8],
  ['nine', 9]
]

cal_sum = 0

input.each do |line|
  nums = []

  line.chars.each.with_index do |c, idx|
    if c == '0' || c.to_i > 0
      nums.push(c.to_i)
      next
    end

    token = numbers.find { |tok| line[idx..-1].start_with?(tok[0]) }
    if token
      nums.push(token[1].to_i)
    end
  end

  cal = nums.first * 10 + nums.last

  cal_sum += cal
end

puts cal_sum
