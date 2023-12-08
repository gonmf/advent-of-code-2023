input = File.read('07.input').split("\n").map(&:strip)

# problem 1

@cards = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse

def score_hand(hand)
  hand = hand.sort
  sameness = hand.group_by { |v| v }.values.map(&:count).sort
  sameness_max = sameness.max || 0

  if sameness_max == 5
    7
  elsif sameness_max == 4
    6
  elsif sameness == [2, 3]
    5
  elsif sameness == [1, 1, 3]
    4
  elsif sameness == [1, 2, 2]
    3
  elsif sameness == [1, 1, 1, 2]
    2
  else
    1
  end
end

def hand_in_alpha(arr)
  arr.map do |c|
    ('a'.ord + @cards.index(c)).chr
  end.join
end

hands_sorted = []
input.each do |line|
  hand, bid = line.split(' ')
  hand = hand.split('')
  bid = bid.to_i
  hand_sorted = hand.sort

  score = score_hand(hand)

  hands_sorted.push([hand.join, hand_in_alpha(hand), score, bid])
end


hands_sorted = hands_sorted.sort { |a, b| a[2] != b[2] ? a[2] <=> b[2] : a[1] <=> b[1] }

p hands_sorted.map.with_index { |v, idx| (idx + 1) * v[3] }.sum

# problem 2

def score_hand(hand)
  hand = hand.sort
  jokers = hand.count { |v| v == 'J' }
  sameness = hand.select { |v| v != 'J' }.group_by { |v| v }.values.map(&:count).sort
  sameness_max = sameness.max || 0

  if sameness_max + jokers == 5
    7
  elsif sameness_max + jokers == 4
    6
  elsif sameness == [2, 3] || sameness == [2, 2]
    5
  elsif sameness == [1, 1, 3] || sameness == [1, 1, 2] || sameness == [1, 1, 1]
    4
  elsif sameness == [1, 2, 2]
    3
  elsif sameness == [1, 1, 1, 2] || sameness == [1, 1, 1, 1]
    2
  else
    1
  end
end

@cards = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse

hands_sorted = []
input.each do |line|
  hand, bid = line.split(' ')
  hand = hand.split('')
  bid = bid.to_i
  hand_sorted = hand.sort

  score = score_hand(hand)

  hands_sorted.push([hand.join, hand_in_alpha(hand), score, bid])
end

hands_sorted = hands_sorted.sort { |a, b| a[2] != b[2] ? a[2] <=> b[2] : a[1] <=> b[1] }

p hands_sorted.map.with_index { |v, idx| (idx + 1) * v[3] }.sum
