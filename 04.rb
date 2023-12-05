input = File.read('04.input').split("\n").map(&:strip)

# problem 1

total = 0

input.each.with_index do |line, card_nr|
  part1, part2 = line.split(' | ')

  winning_numbers = part1.split(': ')[1].split(' ').map(&:to_i)
  have_numbers = part2.split(' ').map(&:to_i)

  matching = winning_numbers.count { |num| have_numbers.include?(num) }
  score = matching > 0 ? (2 ** (matching - 1)) : 0

  total += score
end

puts total

# problem 2

cards = []

input.each.with_index do |line, card_nr|
  part1, part2 = line.split(' | ')

  winning_numbers = part1.split(': ')[1].split(' ').map(&:to_i)
  have_numbers = part2.split(' ').map(&:to_i)

  matching = winning_numbers.count { |num| have_numbers.include?(num) }
  cards.push(Array.new(matching).map.with_index { |v, idx| card_nr + idx + 1 })
end

def count_cards(cards, idx, memo)
  return memo[idx] unless memo[idx].nil?
  return 0 if cards[idx].nil?
  return 1 if cards[idx].size == 0

  res = 1 + cards[idx].map { |v| count_cards(cards, v, memo) }.sum
  memo[idx] = res
  res
end

mem = {}
total = cards.map.with_index { |v, idx| count_cards(cards, idx, mem) }.sum

puts total
