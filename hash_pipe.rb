require 'csv'
require 'awesome_print'

def average_array(array)
  average = array.inject{|sum, el| sum + el} / array.size
end

def create_hash_from_average(data_key, average_data)
  average_hash = {}
  average_data.each do |container|
    average_hash[container[0]] = container[1][data_key]
  end
  average_hash
end

parsed_file = CSV.read('data/metrics.tsv', {:col_sep => "\t"})
containers = {}

parsed_file.each do |data_entry_row|
  if containers.has_key?(data_entry_row[1])
    containers[data_entry_row[1]][:pH].push(data_entry_row[2].to_f)
    containers[data_entry_row[1]][:nsl].push(data_entry_row[3].to_f)
    containers[data_entry_row[1]][:temp].push(data_entry_row[4].to_f)
    containers[data_entry_row[1]][:water_level].push(data_entry_row[5].to_f)

  else
    containers[data_entry_row[1]] = {
        :pH => [data_entry_row[2].to_f],
        :nsl => [data_entry_row[3].to_f],
        :temp => [data_entry_row[4].to_f],
        :water_level => [data_entry_row[5].to_f]
    }
  end
end

average_containers = {}
containers.each do |container|
  average_containers[container[0]] = {
      :avg_pH => average_array(container[1][:pH]),
      :avg_nsl => average_array(container[1][:nsl]),
      :avg_temp => average_array(container[1][:temp]),
      :avg_water_level => average_array(container[1][:water_level])
  }
end

total_average = {
    :total_average_pH => [],
    :total_average_ns_level => [],
    :total_average_temp => [],
    :total_average_water_level => []
}
average_containers.each do |average_container|
  total_average[:total_average_pH].push(average_container[1][:avg_pH])
  total_average[:total_average_ns_level].push(average_container[1][:avg_nsl])
  total_average[:total_average_temp].push(average_container[1][:avg_temp])
  total_average[:total_average_water_level].push(average_container[1][:avg_water_level])
end

total_average[:total_average_pH] = average_array(total_average[:total_average_pH])
total_average[:total_average_ns_level] = average_array(total_average[:total_average_ns_level])
total_average[:total_average_temp] = average_array(total_average[:total_average_temp])
total_average[:total_average_water_level] = average_array(total_average[:total_average_water_level])

average_ph_hash = create_hash_from_average(:avg_pH, average_containers)
average_ns_level_hash = create_hash_from_average(:avg_nsl, average_containers)
average_temperature_hash = create_hash_from_average(:avg_temp, average_containers)
average_water_level_hash = create_hash_from_average(:avg_water_level, average_containers)

highest_average_ph = average_ph_hash.max_by{|k,v| v}
highest_average_ns_level = average_ns_level_hash.max_by{|k,v| v}
highest_average_temperature = average_temperature_hash.max_by{|k,v| v}
highest_average_water_level = average_water_level_hash.max_by{|k,v| v}


p "="*70
p "-"*40
ap "Average of each container's data"
p "-"*40
ap average_containers

p "-"*40
ap "Average of all container data"
p "-"*40
ap total_average

p "-"*40
ap "Containers with the highest levels"
p "-"*40
ap "#{highest_average_ph[0]} has the highest average pH level with #{highest_average_ph[1].round(2)}."
ap "#{highest_average_ns_level[0]} has the highest average Nutrient Solution level with #{highest_average_ns_level[1].round(2)}."
ap "#{highest_average_temperature[0]} has the highest average Temperature with #{highest_average_temperature[1].round(2)}."
ap "#{highest_average_water_level[0]} has the highest average Water level with #{highest_average_water_level[1].round(2)}."
p "="*70
