# http://images.ucomics.com/comics/ga/1990/ga900216.gif

# http://images.ucomics.com/comics/ga/1990/ga900216.gif

require 'RMagick'
require 'open-uri'

def format_image_string
  year = make_year
  year_short = year.to_s[-2..-1]
  month = make_month
  day = make_day
  "http://images.ucomics.com/comics/ga/#{year}/ga#{year_short}#{month}#{day}.gif"
end

def make_day
  day = (1..28).to_a.sample
  if day < 10
    day = "0#{day}"
  end
  day.to_s
end

def make_month
  month = (1..12).to_a.sample
  if month < 10
    month = "0#{month}"
  end
  month.to_s
end

def make_year
  year = (1988..2014).to_a.sample
end

def write_strip(name)
  begin
    url = format_image_string
    image = Magick::ImageList.new
    urlimage = open(url)
    image.from_blob(urlimage.read)
  rescue OpenURI::HTTPError
    puts "porblem. retrying..."
    retry
  else
    puts "we made it, writing image"
    image.write("tmp/strip_#{name}.gif")
  end
end

