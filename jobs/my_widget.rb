# require 'net/http'
# require 'net/https'
# require 'json'
# require 'time'

# require 'net/http'
# require 'net/https'
# require 'rexml/document'


# require 'open-uri'

# open ('http://api.wunderground.com/api/912e47233d90af01/history_20060405/q/TX/Austin.json') do |f|
# 	json_string = f.read
# 	json = JSON.parse(json_string)
# 	observations = json['history']['observations']

# 	@temps = []


# 	observations.each do |obs|
# 		puts "Obs: #{obs['date']['pretty']}: #{obs['tempi']}"
# 		@temps << obs['tempi']
# 	end
# 	@data = {}
# 	@temps.each_with_index do |temp, i|
# 		# puts "#{temp}"
# 		@data[i] = temp.to_i
# 	end


# SCHEDULER.every '60m', first_in: 0 do |job|

# 		puts "Data: #{@data}"
# 		hello = "HEllo"

# 		send_event( 'my_widget', {points: @data})
# 		send_event( 'my_widget', {line: "Line"})
# 		puts "SENT DATA"


# 	end
# end



# i = 1
# SCHEDULER.every '1s', first_in: 0 do |job|
# 	send_event( 'my_widget', {hello: "updating: #{i}"})

# 	i = i+1
# end

# # SCHEDULER.every '10s' do |job|
# # 	puts "MY WIDGET!!!!"
# # 	url = 'http://www.planetary.org/system/rss/channel.jsp?feedID=328434498'
# # 	xml_data = Net::HTTP.get_response(URI.parse(url)).body

# # 	doc = REXML::Document.new(xml_data)
# # 	puts "No errors yet"

# # 	doc.elements.each("*/channel/item/title") do |element|
# # 		puts "Element: #{element.text}"

# # 	end

# # SCHEDULER.every '5s' do |job|
# # 	puts "Scheduling"
# # 	url = 'http://api.wunderground.com/api/912e47233d90af01'


# # 	open('http://api.wunderground.com/api/912e47233d90af01/geolookup/conditions/q/TX/Austin.json') do |f|
# # 		json_string = f.read
# # 		parsed_json = JSON.parse(json_string)
# # 		location = parsed_json['location']['city']
# # 		temp_f = parsed_json['current_observation']['temp_f']
# # 		puts "Current temperature in #{location} is: #{temp_f}\n"
# # 		puts "Wind: #{parsed_json['current_observation']['wind_string']}"
# # 	end





# # end















# 	# http = Net::HTTP.new(url)
# 	# puts "declared http"
# 	# response = http.request(Net::HTTP::Get.new("/geolookup/conditions/q/IA/Cedar_Rapids.json"))
# 	# puts "Got response"
# 	# json = JSON.parse(response.body)
# 	# puts "parsed response"

# 	#   puts "Wind: #{json['wind_mph']}"

# # end