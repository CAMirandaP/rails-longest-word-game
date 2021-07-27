class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @reply = params[:reply]
    @check = check
  end

  private

  def filter_arr(word)
    word.upcase.split('').reject do |letter|
      if @letters.include?(letter)
        idx = @letters.index(letter)
        @letters.delete_at(idx)
      end
    end
  end
 
  def check
    if filter_arr(@reply).any?
      "Lo siento, pero, #{@reply} debe ser una palabra creada con el conjunto de letras, por ejemplo: #{params[:letters]}."
    else
      url = "https://wagon-dictionary.herokuapp.com/#{@reply}"
      reply_serialized = URI.open(url).read
      english_word = JSON.parse(reply_serialized)
      exists = english_word['found']
      exists ? "FELICITACIONES! #{@reply} es una palabra válida en Inglés!" :
      "Lo siento, pero, #{@reply} no es una palabra válida en Inglés..."
    end
  end
end
