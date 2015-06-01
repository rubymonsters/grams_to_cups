require 'minitest'
require 'minitest/autorun'
require 'converter'

class TestIngredient < MiniTest::Test
  def test_cups_per_gr_returns_whatever_for_blackberries
    ingredient = Ingredient.new('blackberries', '100 g', '1 cup')
    assert_equal 0.01, ingredient.cups_per_gr
  end

  def test_cups_per_gr_returns_whatever_for_millet
    ingredient = Ingredient.new('millet', '100 g', '1/2 cup')
    assert_equal 0.005, ingredient.cups_per_gr
  end

  def test_that_ingredients_works_with_one
    ingredient = Ingredient.new('foo', '', '1 cup')
    assert_equal 1, ingredient.us
  end

  def test_that_ingredients_works_with_one_forth_with_cup
    ingredient = Ingredient.new('foo', '', '1/4 cup')
    assert_equal 0.25, ingredient.us
  end

  def test_that_ingredients_works_with_one_forth_with_cups
    ingredient = Ingredient.new('foo', '', '1/4 cups')
    assert_equal 0.25, ingredient.us
  end

  def test_that_ingredients_works_with_one_and_a_half
    ingredient = Ingredient.new('foo', '', '1 1/2')
    assert_equal 1.5, ingredient.us
  end
end


class TestIngredientCsvStore < MiniTest::Test
  def test_reads_ingredients
    store = IngredientCsvStore.new('ingredients.csv')
    ingredients = store.all
    assert ingredients.first.is_a?(Ingredient)
  end
end
