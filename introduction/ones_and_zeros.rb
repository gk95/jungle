# This is implementation of a simple genetic algorithm shown
# in the first chapter of 'An Introduction to Genetic Algorithms' by
# Mitchell Melanie

def random_chromosome(length)
  (1..length).map { rand(0..1) }
end


def init_population(size, length)
  (1..size).map { random_chromosome length }
end


def fittnes(chromosome)
  chromosome.count(1) / chromosome.size.to_f
end


def crossover(a, b, crossover_prob)
  return [a, b] if rand < 1 - crossover_prob

  r_index = rand 0..(a.size-1)

  left_a, right_a = a[0..r_index], a[(r_index + 1)..-1]
  left_b, right_b = b[0..r_index], b[(r_index + 1)..-1]

  [left_a + right_b, left_b + right_a]
end


def mutate(chromosome, p_m)
  chromosome.map { |b| (rand < p_m) ? 1 - b : b }
end


def roulete_wheel_sampling(population, fittnes)
  roulete = []
  population.each_with_index do |chromosome, index|
    n = (fittnes[index] * 100).floor
    roulete += [chromosome] * n
  end

  roulete
end


def next_population(current_population, p_fittnes, p_c, p_m)
  roulete = roulete_wheel_sampling current_population, p_fittnes

  population = []
  while population.size < current_population.size
    # pick
    parent_a, parent_b = roulete.sample 2
    # while parent_b != parent_a
    #   parent_b = roulete.sample
    # end
    offspring_a, offspring_b = crossover parent_a, parent_b, p_c

    # mutate
    offspring_a = mutate offspring_a, p_m
    offspring_b = mutate offspring_b, p_m

    population << offspring_a << offspring_b
  end

  population
end

#
# Params:
# + size - size of the population
# + length - length of chromosomes
# + p_c - probability of crossover
# + p_c - probability of mutation
#
def run(size, length, p_c, p_m, generations = 100)
  population = init_population size, length
  p_fittnes = population.map { |c| fittnes c }

  generations.times do
    best = p_fittnes.each_with_index.max 1
    best.each do |fit, i|
      puts "#{population[i].join} fittnes #{fit}"
    end

    population = next_population population, p_fittnes, p_c, p_m
    p_fittnes = population.map { |c| fittnes c }
  end

  best = p_fittnes.each_with_index.max 1
  best.each do |fit, i|
    puts "#{population[i].join} fittnes #{fit}"
  end

  population[best[0][1]].join
end

# example
run 4, 8, 0.7, 0.001
