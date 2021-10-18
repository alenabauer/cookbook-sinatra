require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    read_csv
  end

  def all
    # return the array of all Recipe instances
    @recipes
  end

  def add_recipe(recipe)
    # create array of name and description of the recipe
    # add this array as a new line in the csv file
    @recipes << recipe
    update_csv(@recipes)
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    update_csv(@recipes)
  end

  def mark_as_done!(recipe_index)
    @recipes[recipe_index].done = true
    update_csv(@recipes)
  end

  private

  def read_csv
    CSV.foreach(@csv_file_path, col_sep: ',') do |row|
      @recipes << Recipe.new(row[0], row[1], row[2].to_i, row[3], row[4])
    end
  end

  def update_csv(array)
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

    CSV.open(@csv_file_path, 'w', csv_options) do |csv|
      array.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.done, recipe.prep_time]
      end
    end
  end
end
