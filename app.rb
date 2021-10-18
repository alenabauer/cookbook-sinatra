require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "nokogiri"
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scraper'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

cookbook = Cookbook.new('recipes.csv')

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :form
end

get '/import' do
  erb :import
end

post '/recipes' do
  @new_recipe = Recipe.new(params[:rname], params[:rdescription], params[:rating], false, params[:preptime])
  cookbook.add_recipe(@new_recipe)
  redirect '/'
end

post '/delete' do
  index = params.keys[0].to_i
  cookbook.remove_recipe(index)
  redirect '/'
end

post '/mark' do
  index = params.keys[0].to_i
  cookbook.mark_as_done!(index)
  redirect '/'
end

post '/search_results' do
  @ingredient = params[:ingredient]
  url = "https://www.allrecipes.com/search/results/?search=#{@ingredient}"
  @scraper = Scraper.new(url)
  @results = @scraper.provide_first_five
  erb :search_results
end

post '/import_one' do
  @ingredient = params[:ingredient]
  user_index = params.keys[1].to_i
  url = "https://www.allrecipes.com/search/results/?search=#{@ingredient}"
  @scraper = Scraper.new(url)
  @imported_recipe_name = @scraper.find_name(user_index)
  @imported_recipe_description = @scraper.find_description(user_index)
  @imported_recipe_rating = @scraper.find_rating(user_index)
  @imported_recipe_prep_time = @scraper.find_prep_time(user_index)

  @imported_recipe = Recipe.new(@imported_recipe_name, @imported_recipe_description, @imported_recipe_rating, false, @imported_recipe_prep_time)
  cookbook.add_recipe(@imported_recipe)

  redirect '/'
end
