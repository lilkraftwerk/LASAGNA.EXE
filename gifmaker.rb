# http://www.mezzacotta.net/garfield/?comic=8
# http://studio.imagemagick.org/RMagick/doc/usage.html
# to do
# get random frames
# fuck them all up a lot
# add a lot of garkov
# turn into animated gif
# profit

# http://video.stackexchange.com/questions/12905/repeat-loop-input-video-with-ffmpeg
# https://trac.ffmpeg.org/wiki/Concatenate
# http://www.labnol.org/internet/useful-ffmpeg-commands/28490/


require 'rmagick'
include Magick
require_relative 'garkov'
require_relative 'custom_twitter'
require_relative 'scrape'


def random_color
  %w( pink red orange white yellow blue cyan teal purple ).shuffle.shift
end

def fuck_up_image(image)
  image = image.shear(rand(30) + 30, rand(30) + 30) if roll_dice
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

def fuck_up_image_less(image)
  image = image.shear(rand(90), 0) if roll_dice
  image = image.roll(rand(90), rand(90)) if roll_dice
  image = image.wave(rand(20), rand(20)) if roll_dice
  image = image.solarize if roll_dice
  image = image.blur_image(2, rand(1..5)) if roll_dice
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
    gifs << "tmp/strip_#{x}.gif"
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

  3.times do
    new_image = fuck_up_image(new_image) if roll_dice
  end
  new_image.write("tmp/gen_#{file_number}.png")
end


def tweet
  number_of_times = 30

  number_of_times.times do |x|
    puts "writing strip #{x}"
    write_strip(x)
  end

  number_of_times.times do |x|
    create_image(x)
    puts "did number #{x}"
  end

  anim = ImageList.new(
   "tmp/gen_0.png", "tmp/gen_1.png", "tmp/gen_2.png", "tmp/gen_3.png", "tmp/gen_4.png", "tmp/gen_5.png", "tmp/gen_6.png", "tmp/gen_7.png", "tmp/gen_8.png", "tmp/gen_9.png", "tmp/gen_10.png", "tmp/gen_11.png", "tmp/gen_12.png", "tmp/gen_13.png", "tmp/gen_14.png", "tmp/gen_15.png", "tmp/gen_16.png", "tmp/gen_17.png", "tmp/gen_18.png", "tmp/gen_19.png", "tmp/gen_20.png", "tmp/gen_21.png", "tmp/gen_22.png", "tmp/gen_23.png", "tmp/gen_24.png", "tmp/gen_25.png", "tmp/gen_26.png", "tmp/gen_27.png", "tmp/gen_28.png", "tmp/gen_29.png")

  anim.ticks_per_second = 100
  anim.delay = rand(5..10)
  anim.iterations = 0

  g = Garkov.new
  sentence = g.fucked_up_sentence
  twitter = GarfTwitter.new
  filename = "tmp/animated_#{rand(1000)}.gif"
  anim.write(filename)

  File.open(filename) do |f|
    twitter.update(sentence, f)
  end
end




