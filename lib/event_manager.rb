require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

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


## Parsing with csv ITERATION 2
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


## Using Google's civic information ITERATION 3
#def legislators_by_zipcode(zip)
#  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
#  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
#
#  begin
#    legislators = civic_info.representative_info_by_address(
#      address: zip,
#      levels: 'country',
#      roles: ['legislatorUpperBody', 'legislatorLowerBody']
#    )
#    legislators = legislators.officials
#    legislator_names = legislators.map(&:name)
#    legislator_names.join(", ")
#  rescue
#    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
#  end
#end
#
#def clean_zipcode(zipcode)
#  zipcode.to_s.rjust(5, '0')[0..4]
#end
#
#puts 'EventManager initialized.'
#
#contents = CSV.open(
#  'event_attendees.csv',
#  headers: true,
#  header_converters: :symbol
#)
#
#contents.each do |row|
#  name = row[:first_name]
#
#  zipcode = clean_zipcode(row[:zipcode])
#
#  legislators = legislator_by_zipcode(zipcode)
#
#  puts "#{name} #{zipcode} #{legislators}"
#end

## Iteration 4: Form letters
## %{} is one choice when defining a string that spans mutiple lines
#puts "EventManager initialized."
#template_letter = File.read('form_letter.html')

#contents = CSV.open(
#  'event_attendees.csv',
#  headers: true,
#  header_converters: :symbol
#)

#contents.each do |row|
#  name = row[:first_name]
#
#  zipcode = clean_zipcode(row[:zipcode])
#
#  legislators = legislators_by_zipcode(zipcode)
#
#  personal_letter = template_letter.gsub('FIRST_NAME', name)
#  personal_letter.gsub!('LEGISLATORS', legislators)
#
#  #puts personal_letter
#end

## ----------------------------------------------------

puts "EventManager initialized."

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def clean_phonenumber(phone)
  phone.to_s.gsub!(/\D/, "")
  puts phone.length() == 10 || phone.length() == 11 ? phone.length() == 11 ? phone.slice!(1..-1) : phone : "Bad number"
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

content_size = File.read('event_attendees.csv').length
template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

reg_hour = []
reg_date = []
j = 0

araw = {0 => "Sunday", 1 => "Monday", 2 => "Tuesday", 3 => "Wednesday", 4 => "Thursday", 5 => "Friday", 6 => "Saturday"}
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone = row[:homephone]
  regdate = row[:regdate]

  form_letter = erb_template.result(binding)

  reg_date_to_print =  DateTime.strptime(regdate, "%m/%d/%Y %k:%M")

  reg_hour[j] = reg_date_to_print.hour
  reg_date[j] = reg_date_to_print.wday
  j += 1 

  save_thank_you_letter(id, form_letter)

  clean_phonenumber(phone)
end

def day(arr)
  freq = arr.inject(Hash.new(0)) { |h, v| h[v] += 1; h}
  arr.max_by { |v| freq[v]}
end

def days_to_target(arr, araw)
  repetead_values = arr.group_by { |i| i }
    .select { |k, v| v.length > 1}
    .keys

  j = 0
  while j < repetead_values.length
    puts "#{araw[repetead_values[j]]}" 
    j += 1
  end
  puts "are/is the busiest"
end

puts "\n#{araw[day(reg_date)]} is the day where people registered the most"
puts "1pm is the most active hour that people registers\n\n" if day(reg_hour) == 13

days_to_target(reg_date, araw)
##----------------------------------------------------------------