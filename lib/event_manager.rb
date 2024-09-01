require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

DAYS_OF_WEEK = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_number(number)
  digits = number.gsub(/[^0-9]/, "")

  return 'invalid phone number' unless digits.length == 10 || (digits.length == 11 && digits[0] == 1)

  digits.length == 10 ? digits : digits[1..-1]
end

def clean_time(string)
  clean_time_date_formatted = Time.strptime(string, "%m/%d/%y %H:%M")
end

def weekday_from_wday(num)
  DAYS_OF_WEEK[num]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip

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

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone = clean_phone_number(row[:homephone])
  hour = clean_time(row[:regdate]).hour
  weekday = weekday_from_wday(clean_time(row[:regdate]).wday)
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)
end