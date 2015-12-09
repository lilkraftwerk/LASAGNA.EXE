read = File.open('alltext.txt', 'r').read

read.gsub!(/^.+--\s/, '')
read.gsub!(' - ', '')
read.gsub!('- ', '')

File.write('scraped.txt', read)