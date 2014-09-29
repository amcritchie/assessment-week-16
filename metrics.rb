require 'awesome_print'
require 'csv'

file = CSV.read('data/metrics.tsv', {:col_sep => "\t"})
containers = {}

file.each do |array|
  if containers.has_key?(array[1])
    containers[array[1]][:ph].push(array[2].to_f)
    containers[array[1]][:nsl].push(array[3].to_f)
    containers[array[1]][:temp].push(array[4].to_f)
    containers[array[1]][:wl].push(array[5].to_f)
  else
    containers[array[1]] = {
        :ph => [array[2].to_f],
        :nsl => [array[3].to_f],
        :temp => [array[4].to_f],
        :wl => [array[5].to_f],
    }
  end
end

def add_key_value ()

containers
containers_avg = {}

def average_total_data(key, containers)
  array = []
  containers.each do |container|
    container[1][key].each do |ele|
      array.push(ele)
    end
  end
  average_of_elements(array)
end


def highest_absolute_data(key, containers)
  highest = 0
  container_name = ''
  containers.each do |container|
    container[1][key].each do |ele|
      if highest <= ele
        highest = ele
        container_name = container[0]
      end
    end
  end
  container_name
end


def average_of_elements(array)
  counter = 0
  total = 0
  array.each do |ele|
    total += ele
    counter += 1
  end
  total/counter
end

def find_highest_avg(key, containers)
  current_highest = 0
  highest_container = ''
  containers.each do |container|
    if container[1][key] >= current_highest
      current_highest = container[1][key]
      highest_container = container[0]
    end
  end
  highest_container
end

containers.each do |container|
  # p average_of_elements(container[1][:ph])
  containers_avg[container[0]] = {
      :avg_ph => average_of_elements(container[1][:ph]),
      :avg_nsl => average_of_elements(container[1][:nsl]),
      :avg_temp => average_of_elements(container[1][:temp]),
      :avg_wl => average_of_elements(container[1][:wl])
  }
end


ap find_highest_avg(:avg_temp, containers_avg)
ap find_highest_avg(:avg_ph, containers_avg)
ap find_highest_avg(:avg_nsl, containers_avg)
ap find_highest_avg(:avg_wl, containers_avg)

ap average_total_data(:ph, containers)
ap average_total_data(:nsl, containers)
ap average_total_data(:temp, containers)
ap average_total_data(:wl, containers)

ap highest_absolute_data(:ph, containers)

# ap containers_avg