require 'marky_markov'


class Garkov

  def initialize
    @markov = MarkyMarkov::TemporaryDictionary.new
    @markov.parse_file('scraped.txt')
  end

  def sentence
    @markov.generate_1_sentence
  end
end