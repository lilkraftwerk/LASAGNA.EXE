# http://www.mezzacotta.net/garfield/?comic=8
# http://studio.imagemagick.org/RMagick/doc/usage.html
# to do
# get random frames
# fuck them all up a lot
# add a lot of garkov
# turn into animated gif
# profit


require 'rmagick'
include Magick
require_relative 'garkov'
require_relative 'scrape'

def word_wrap(text, columns = 80)
    text.split("\n").collect do |line|
        line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
end

def make_slogan
  garfield = Magick::ImageList.new('images/garf.jpg')
  new_image = Image.new(800, 600)
  new_image.composite!(garfield, 300, 50, Magick::OverCompositeOp)
  text = Magick::Draw.new
  text.font = "Garfield.ttf"

  garkov = Garkov.new
  sentence = garkov.sentence
  sentence = word_wrap(sentence, 100)
  p sentence

  text.annotate(new_image, 800, 600, 50, 500, garkov.sentence.upcase) {
      self.fill = 'black'
      self.pointsize = 45
      self.font_weight = BoldWeight
  }


  new_image.write("output/slogan_#{rand(1000)}.gif")
end


1.times do |x|
  make_slogan
end