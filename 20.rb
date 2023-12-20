require 'json'

input = File.read('20.input').split("\n").map(&:strip)

# problem 1

modules_by_name = {}

input.each do |line|
  name, dests = line.split(' -> ')
  dests = dests.split(', ')
  type = 'broad'
  value = nil

  if name[0] == '%'
    type = 'flop'
    name = name[1..-1]
    value = 'off'
  elsif name[0] == '&'
    type = 'conj'
    name = name[1..-1]
    value = 'low'
  end

  modules_by_name[name] = {
    'type' => type,
    'dests' => dests,
    'value' => value,
    'inputs' => {}
  }
end

modules_by_name.each do |key, value|
  value['dests'].each do |dest|
    modules_by_name[dest]['inputs'][key] = 'low' if modules_by_name[dest]
  end
end

modules_by_name_bak = JSON.parse(JSON.generate(modules_by_name))

total_high = 0
total_low = 0

(0...1000).each do
  pulses = [['button', 'broadcaster', 'low']]

  while pulses.any?
    pulse = pulses.shift
    pulse_input, pulse_destinaton, pulse_value = pulse

    total_high += 1 if pulse_value == 'high'
    total_low += 1 if pulse_value == 'low'

    mod = modules_by_name[pulse_destinaton]
    next if mod.nil?

    if mod['type'] == 'broad'
      mod['dests'].each do |dest|
        pulses.push([pulse_destinaton, dest, pulse_value])
      end
    elsif mod['type'] == 'flop'
      if pulse_value == 'low'
        if mod['value'] == 'off'
          mod['value'] = 'on'
          mod['dests'].each do |dest|
            pulses.push([pulse_destinaton, dest, 'high'])
          end
        else
          mod['value'] = 'off'
          mod['dests'].each do |dest|
            pulses.push([pulse_destinaton, dest, 'low'])
          end
        end
      end
    elsif mod['type'] == 'conj'
      mod['inputs'][pulse_input] = pulse_value
      to_send = mod['inputs'].values.all? { |v| v == 'high' } ? 'low' : 'high'
      mod['dests'].each do |dest|
        pulses.push([pulse_destinaton, dest, to_send])
      end
    end
  end
end

p total_high * total_low

# problem 2

modules_by_name = modules_by_name_bak

to_find = modules_by_name['df']['inputs'].keys
found = {}

presses = 0

while true
  pulses = [['button', 'broadcaster', 'low']]
  presses += 1

  while pulses.any?
    pulse = pulses.shift
    pulse_input, pulse_destinaton, pulse_value = pulse

    mod = modules_by_name[pulse_destinaton]
    next if mod.nil?

    if mod['type'] == 'broad'
      mod['dests'].each do |dest|
        pulses.push([pulse_destinaton, dest, pulse_value])
      end
    elsif mod['type'] == 'flop'
      if pulse_value == 'low'
        if mod['value'] == 'off'
          mod['value'] = 'on'
          mod['dests'].each do |dest|
            pulses.push([pulse_destinaton, dest, 'high'])
          end
        else
          mod['value'] = 'off'
          mod['dests'].each do |dest|
            pulses.push([pulse_destinaton, dest, 'low'])
          end
        end
      end
    elsif mod['type'] == 'conj'
      if pulse_destinaton == 'df' && pulse_value == 'high' && to_find.include?(pulse_input)
        found[pulse_input] = found[pulse_input] || presses

        if found.count == to_find.count
          res = nil
          found.values.each do |v|
            res = res&.lcm(v) || v
          end
          p res
          exit
        end
      end

      mod['inputs'][pulse_input] = pulse_value
      to_send = mod['inputs'].values.all? { |v| v == 'high' } ? 'low' : 'high'
      mod['dests'].each do |dest|
        pulses.push([pulse_destinaton, dest, to_send])
      end
    end
  end
end
