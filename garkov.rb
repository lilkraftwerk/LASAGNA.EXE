require 'marky_markov'

class Garkov

  def initialize
    @markov = MarkyMarkov::TemporaryDictionary.new
    @markov.parse_file('scraped.txt')
  end

  def roll_dice
    rand(15) == 5
  end

  def sentence
    @markov.generate_1_sentence
  end

  def fucked_up_sentence
    regex = /(?<=.),(?=.)/
    sentence = @markov.generate_1_sentence.gsub(regex, '. ')
    until sentence.length < 120
      sentence = @markov.generate_1_sentence.gsub(regex, '. ')
    end

    sentence = sentence.split('')

    new_sentence = []
    sentence.each do |letter|
      letter = ['_', '#', '=', '^', '&', '$', '(', '!', '?', '/', '%'].sample if roll_dice
      letter = letter.upcase if roll_dice
      letter = letter.downcase if roll_dice
      new_sentence.push(letter)
    end

    final_sentence = new_sentence.join("")
  end
end

