class Recipe
  attr_reader :name, :description, :rating, :prep_time
  attr_accessor :done

  def initialize(name, description, rating, done, prep_time)
    @name = name
    @description = description
    @rating = rating
    @prep_time = prep_time
    @done = done
  end

  def done?
    @done == "true" || @done == true
  end
end
