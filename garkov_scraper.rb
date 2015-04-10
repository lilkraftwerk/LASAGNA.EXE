f = File.open('alltext.txt', 'r')

read = f.read

read.gsub!(/^.+--\s/, '')
read.gsub!(' - ', '')
read.gsub!('- ', '')



File.write('scraped.txt', read)