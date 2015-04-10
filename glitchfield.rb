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


def random_color
  %w( pink red orange white yellow blue cyan teal purple ).shuffle.shift
end

def fuck_up_image(image)
  image = image.shear(rand(180), 0) if roll_dice
  image = image.roll(rand(180), rand(180)) if roll_dice

  if roll_dice
    [1, 2, 3].sample.times do
      image = image.transverse
    end
  end

  if roll_dice
    [1, 2, 3].sample.times do
      image = image.transpose
    end
  end

  image = image.wave(rand(50), rand(50)) if roll_dice

  image = image.solarize if roll_dice

  image = image.blur_image(2, rand(1..10)) if roll_dice

  image = image.radial_blur(rand(10)) if roll_dice

  image
end

def roll_dice
  rand(3) == 2
end

def create_image(file_number)
  puts "creating image #{file_number}"
  text = Magick::Draw.new
  text.font = "Garfield.ttf"

  garkov = Garkov.new
  sentence = garkov.sentence

  gifs = []

  10.times do |x|
    gifs << "tmp/#{x}.gif"
  end

  gifs.shuffle!

  image1 = Magick::ImageList.new(gifs.shift)
  image2 = Magick::ImageList.new(gifs.shift)
  image3 = Magick::ImageList.new(gifs.shift)
  cropped1 = image3.crop(0, 0, 200, 178)
  cropped2 = image2.crop(200, 0, 200, 178)
  cropped3 = image1.crop(400, 0, 200, 178)

  new_image = Image.new(600, 178)

  cropped1 = fuck_up_image(cropped1)
  cropped2 = fuck_up_image(cropped2)
  cropped3 = fuck_up_image(cropped3)

  new_image.composite!(cropped1, 0, 0, Magick::OverCompositeOp)
  new_image.composite!(cropped2, 200, 0, Magick::OverCompositeOp)
  new_image.composite!(cropped3, 400, 0, Magick::OverCompositeOp)


  rand(5).times do
    text.annotate(new_image, rand(500), rand(178), rand(600), rand(178), garkov.sentence.upcase) {
        self.fill = random_color
        self.pointsize = rand(30)
        self.rotation = (rand(20) - 10)
        self.font_weight = BoldWeight
    }
  end

  new_image = new_image.resize_to_fit(1200, 356)

  new_image.write("tmp/gen_#{file_number}.gif")
end


number_of_times = 10

number_of_times.times do |x|
  puts "writing strip #{x}"
  write_strip(x)
end

number_of_times.times do |x|
  create_image(x)
  puts "did number #{x}"
end


anim = ImageList.new("tmp/gen_1.gif", "tmp/gen_2.gif", "tmp/gen_3.gif", "tmp/gen_5.gif", "tmp/gen_4.gif", "tmp/gen_6.gif", "tmp/gen_8.gif", "tmp/gen_7.gif", "tmp/gen_9.gif", "tmp/gen_0.gif")
anim.ticks_per_second = 100
anim.delay = rand(8..15)
anim.iterations = 0





anim.write("output/animated_#{rand(1000)}.gif")



