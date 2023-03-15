require 'csv'

contents = CSV.open(
    'event_attendees.csv',
    headers: true, 
    header_converters: :symbol
)

def clean_phonenumber(phone)
    phone.to_s.gsub!(/\D/, "")
    puts phone.length() == 10 || phone.length() == 11 ? phone.length() == 11 ? phone.slice!(1..-1) : phone : "Bad number"
end

contents.each do |row|
    phone = row[:homephone]
    clean_phonenumber(phone)
end