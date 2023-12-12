input = File.read('12.input').split("\n").map(&:strip)

# problem 1

def search(springs, goals, memo)
  memo_key = [(springs&.join || ''), goals.join(',')].join(';')
  cached = memo[memo_key]
  return cached unless cached.nil?

  if goals.count == 0
    if !springs || !springs.include?('#')
      memo[memo_key] = 1
      return 1
    end
    memo[memo_key] = 0
    return 0
  end

  if springs.nil? || springs.count < goals.sum + goals.count - 1 || springs.count { |s| s != '.' } < goals.sum
    memo[memo_key] = 0
    return 0
  end

  current_goal = goals.first

  if springs[0] == '.'
    res = search(springs[1..-1], goals, memo)
    memo[memo_key] = res
    return res
  end

  if springs[0] == '#'
    head = springs[0...current_goal]

    if head.include?('.')
      memo[memo_key] = 0
      return 0
    elsif springs[current_goal] && springs[current_goal] == '#'
      memo[memo_key] = 0
      return 0
    else
      res = search(springs[(current_goal + 1)..-1], goals[1..-1], memo)
      memo[memo_key] = res
      return res
    end
  end

  if springs[0] == '?'
    head = springs[0...current_goal]
    head_index_of_empty = head.index('.')

    if head.include?('.')
      res = search(springs[1..-1], goals, memo)
      memo[memo_key] = res
      return res
    elsif springs[current_goal] && springs[current_goal] == '#'
      res = search(springs[1..-1], goals, memo)
      memo[memo_key] = res
      return res
    else
      res = search(springs[1..-1], goals, memo) + search(springs[(current_goal + 1)..-1], goals[1..-1], memo)
      memo[memo_key] = res
      return res
    end
  end
end

memo = {}
total = 0

input.each do |line|
  springs, seqs = line.split(' ')

  springs = springs.split('.').select { |s| s.size > 0 }.join('.').chars
  seqs = seqs.split(',').map(&:to_i)

  total += search(springs, seqs, memo)
end

p total

# problem 2

total = 0

input.each do |line|
  springs, seqs = line.split(' ')

  springs = Array.new(5, springs).join('?')
  seqs = Array.new(5, seqs).join(',')

  springs = springs.split('.').select { |s| s.size > 0 }.join('.').chars
  seqs = seqs.split(',').map(&:to_i)

  total += search(springs, seqs, memo)
end

p total
