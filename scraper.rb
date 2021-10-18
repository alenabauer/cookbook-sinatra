require 'open-uri'
require 'nokogiri'

class Scraper
  def initialize(url)
    @url = url
    @html_doc = Nokogiri::HTML(URI.open(url).read)
  end

  def provide_first_five
    @first_five = []
    @html_doc.search('.card__title')[0..4].each_with_index do |element|
      @first_five << element.text.strip
    end
    return @first_five
  end

  def find_name(user_index)
    # @html_doc.search('.card__title')[user_index].each do |element|
    #   @imported_recipe_name = element.text.strip
    # end
    @html_doc.search('.card__title')[user_index].text.strip
  end

  def find_description(user_index)
    @html_doc.search('.card__summary')[user_index].text.strip
  end

  def find_rating(user_index)
    @html_doc.search(".ratings-dropdown-button")[user_index].children.search('.active').count
    # @html_doc.search('.review-star-text').each_with_index do |element, index|
    #   @imported_recipe_rating = (element.text.strip.tr('^0-9', '').to_i / 100.00).round if index == user_index
    # end
    # return @imported_recipe_rating
  end

  def find_prep_time(user_index)
    @imported_recipe_url = @html_doc.search('.card__titleLink')[user_index].attribute('href').value
    @recipe_html_doc = Nokogiri::HTML(URI.open(@imported_recipe_url).read)
    return @recipe_html_doc.search('.recipe-meta-item-body')[0].text.strip
  end
end
