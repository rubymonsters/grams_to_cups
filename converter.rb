# TODO compare to: http://www.fao.org/docrep/017/ap815e/ap815e.pdf
# 237 ml milk  == 1 cup
# 236.59 ml water == 1 cup
# GR_PER_CUPS_OF_WATER = 237
# CUPS_OF_WATER_PER_GR = 1 / 237

require 'csv'

class Ingredient
  attr_reader :name, :metric, :us

  def initialize(name, metric, us)
    @name = name.strip
    @metric = metric.gsub(' g', '').to_f
    @us = to_frac(us.gsub(/ cups?/, ''))
  end

  def cups_per_gr
    us / metric
  end

  def to_frac(string)
    right, left = string.split(' ').reverse
    numerator, denominator = right.split('/').map(&:to_f)
    denominator ||= 1
    left.to_i + numerator / denominator
  end
end

class IngredientCsvStore
  def initialize(filename)
    @filename = filename
    @ingredients = []
    parse
  end

  def [](name)
    all.detect { |ingredient| ingredient.name == name }
  end

  def all
    @ingredients
  end

  def parse
    CSV.new(csv, :col_sep => ';', :headers => true).each do |row|
      next unless valid_row?(row)
      @ingredients << Ingredient.new(row['ingredient'], row['metric'], row['us'])
    end
  end

  def csv
    File.read(@filename)
  end

  def valid_row?(row)
    metric, us = row.values_at('metric', 'us')
    metric && gram?(metric) && us && cup?(us)
  end

  def gram?(string)
    string[-1] == 'g'
  end

  def cup?(string)
    string.include?('cup')
  end
end

name = ARGV[0]
grams = ARGV[1].to_f

store = IngredientCsvStore.new('ingredients.csv')
ingredient = store[name]
cups = ingredient.cups_per_gr * grams

puts "#{grams}g #{name} in cups: #{cups}"

# ingredients = store.all
# butter = ingredients.detect { |ingredient| ingredient.name == 'Butter' }
#
# ingredients.each do |ingredient|
#   puts [ingredient.name, ingredient.cups_per_gr].join(' ')
#   # puts "#{ingredient.name}: #{ingredient.us}"
# end
#
#
#
