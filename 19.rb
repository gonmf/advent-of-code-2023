input = File.read('19.input').split("\n").map(&:strip)

# problem 1

def parse_part(str)
  str = str.tr('{}', '')
  res = {}

  str.split(',').each do |s|
    atr, val = s.split('=')
    res[atr] = val.to_i
  end

  res
end

def parse_workflow(str, workflows)
  name = str.split('{')[0]
  str = str.split('{')[1].tr('{}', '')

  res = []

  str.split(',').each do |s|
    cond_var = nil
    cond_oper = nil
    cond_val = nil
    dest = nil

    if s.include?(':')
      cond, dest = s.split(':')

      ['<', '>'].each do |oper|
        if cond.include?(oper)
          cond_oper = oper
          cond_var, cond_val = cond.split(oper)
          cond_val = cond_val.to_i
        end
      end
    else
      dest = s
    end

    res.push({ 'var' => cond_var, 'op' => cond_oper, 'val' => cond_val, 'dst' => dest })
  end

  workflows[name] = res
end

workflows = {}
parts = []

input.each do |line|
  if line[0] == '{'
    parts.push(parse_part(line))
  elsif line.size > 0
    parse_workflow(line, workflows)
  end
end

def evaluate_step(var, op, val, vars)
  var_val = vars[var]

  if op == '<'
    return var_val < val
  end
  if op == '>'
    return var_val > val
  end
end

def execute_workflow(part, workflow_name, workflows)
  if workflow_name == 'A'
    return true
  end
  if workflow_name == 'R'
    return false
  end


  workflow = workflows[workflow_name]

  workflow.each do |step|
    if step['var']
      if evaluate_step(step['var'], step['op'], step['val'], part)
        return execute_workflow(part, step['dst'], workflows)
      end
    else
      return execute_workflow(part, step['dst'], workflows)
    end
  end

  true
end

sum = 0

parts.each do |part|
  if execute_workflow(part, 'in', workflows)
    sum += part.values.sum
  end
end

p sum

# problem 2

def expand_flow(ranges, workflow_name, workflow_step, workflows, res)
  if workflow_name == 'A'
    total = 1
    ranges.values.each do |range|
      total *= range[1] - range[0] + 1
    end
    res[0] += total
    return
  end
  if workflow_name == 'R'
    return
  end

  workflow = workflows[workflow_name]

  step = workflow[workflow_step]

  if step['var']
    range = ranges[step['var']]
    min, max = range

    if step['op'] == '>'
      min = [min, step['val'] + 1].max
    elsif step['op'] == '<'
      max = [max, step['val'] - 1].min
    end

    if min <= max
      new_ranges = { 'x' => ranges['x'], 'm' => ranges['m'], 'a' => ranges['a'], 's' => ranges['s'] }
      new_ranges[step['var']] = [min, max]
      expand_flow(new_ranges, step['dst'], 0, workflows, res)
    end

    min, max = range

    if step['op'] == '>'
      max = [max, step['val']].min

      if min <= max
        new_ranges = { 'x' => ranges['x'], 'm' => ranges['m'], 'a' => ranges['a'], 's' => ranges['s'] }
        new_ranges[step['var']] = [min, max]
        return expand_flow(new_ranges, workflow_name, workflow_step + 1, workflows, res)
      end
    elsif step['op'] == '<'
      min = [min, step['val']].max

      if min <= max
        new_ranges = { 'x' => ranges['x'], 'm' => ranges['m'], 'a' => ranges['a'], 's' => ranges['s'] }
        new_ranges[step['var']] = [min, max]
        return expand_flow(new_ranges, workflow_name, workflow_step + 1, workflows, res)
      end
    end
  else
    return expand_flow(ranges, step['dst'], 0, workflows, res)
  end
end

ranges = { 'x' => [1, 4000], 'm' => [1, 4000], 'a' => [1, 4000], 's' => [1, 4000] }

res = [0]
expand_flow(ranges, 'in', 0, workflows, res)
puts res[0]
