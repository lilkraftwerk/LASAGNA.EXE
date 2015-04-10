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

  image = image.solarize if roll_dice

  image = image.radial_blur(rand(10)) if roll_dice
  image
end

def roll_dice
  rand(3) == 2
end

def create_image(file_number)
  image1 = Magick::ImageList.new("1.gif")
  image2 = Magick::ImageList.new("2.gif")
  image3 = Magick::ImageList.new("3.gif")
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

end

image1 = Magick::ImageList.new("1.gif")
image2 = Magick::ImageList.new("2.gif")
image3 = Magick::ImageList.new("3.gif")

cropped1 = image3.crop(0, 0, 200, 178)
cropped2 = image2.crop(200, 0, 200, 178)
cropped3 = image1.crop(400, 0, 200, 178)

# cropped1 = cropped1.shear(rand(180), 0)
# cropped2 = cropped2.radial_blur(10)
# # cropped3 = cropped3.wave()
# cropped3 = cropped3.wave(25, 150)

# cropped1 = cropped1.roll(10, 100)
# cropped2 = cropped2.transverse
# # cropped3 = cropped3.transverse

new_image = Image.new(600, 178)

cropped1 = fuck_up_image(cropped1)
cropped2 = fuck_up_image(cropped2)
cropped3 = fuck_up_image(cropped3)




# dest.composite!(src, x, y, composite_op) -> self

new_image.composite!(cropped1, 0, 0, Magick::OverCompositeOp)
new_image.composite!(cropped2, 200, 0, Magick::OverCompositeOp)
new_image.composite!(cropped3, 400, 0, Magick::OverCompositeOp)

garkov = Garkov.new
sentence = garkov.sentence

anim = ImageList.new("1.gif", "2.gif", "3.gif")

text = Magick::Draw.new
text.font = "Garfield.ttf"

rand(5).times do
  text.annotate(new_image, rand(500), rand(178), rand(600), rand(178), garkov.sentence) {
      self.fill = 'black'
      self.pointsize = 12
      self.font_weight = BoldWeight
  }
end

new_image.write("23.gif")


puts sentence

