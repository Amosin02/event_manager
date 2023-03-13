require 'csv'
puts 'Event Manager Initialized!'

#contents = File.read('event_attenndees.csv')
#puts contents

#lines = File.readlines('event_attendees.csv')
#lines.each do |line|

#     read the file line by line
#    puts line
#    
#     read and prints the first names
#    next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
#    columns = line.split(",")
#    p columns
#    name = columns[2]
#    puts name
#end

# can still be used to print the names even if the header row change in the future
#lines = File.readlines('event_attendees.csv')
#row_index = 0
#lines.each do |line|
#    row_index += 1
#    next if row_index == 1
#    columns = line.split(",")
#    name = columns[2]
#    puts name
#end

# Parsing with csv ITERATION 1
#contents = CSV.open('event_attendees.csv', headers: true)
#contents.each do |row|
#    name = row[2]
#    puts name
#end

# Accessing columns by their names
#contents = CSV.open(
#  'event_attendees.csv',
#  headers: true,
#  header_converters: :symbol
#)
#
#contents.each do |row|
#  name = row[:first_name] # The values inside [] should be uniform to extract the values
#  last_name = row[:last_name]
#  zip = row[:zipcode]
#  puts "#{name} #{last_name} : #{zip}"
#end


# Parsing with csv ITERATION 2

#def clean_zipcode(zipcode)
#    if zipcode.nil?
#      '00000'
#    elsif zipcode.length < 5
#      zipcode.rjust(5, '0')
#    elsif zipcode.length > 5
#      zipcode[0..4]
#    else
#      zipcode
#    end
#  end

#def clean_zipcode(zipcode)
#  zipcode.to_s.rjust(5, '0')[0..4]
#end
#
#contents = CSV.open(
#  'event_attendees.csv',
#  headers: true,
#  header_converters: :symbol
#)
#
#contents.each do |row|
#  name = row[:first_name]
#  zipcode = clean_zipcode(row[:zipcode])
  # if the zip code is exactly five digits, assume that it is ok
  # if the zip code is more than five digits, truncate it to the first five digits
  # if the zip code is less than five digits, add zeros to the front until it becomes five digits

#  if zipcode.nil?
#    zipcode = '00000'
#  elsif zipcode.length < 5
#    zipcode = zipcode.rjust(5, '0')
#  elsif zipcode.length > 5
#    zipcode = zipcode[0..4]
#  end

#  puts "#{name} #{zipcode}"
#end


# Using Google's civic information ITERATION 3
