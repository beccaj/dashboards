require 'open-uri'
require 'csv'
require 'set'

i = 1
@network_sizes = Set.new
@country_hash = Hash.new
@countries = Set.new

@graph_data = []

url = 'http://spiceworksdata/users/users_by_country_and_network_size'

file_string = ""
open (url) do |f|
	puts "Opened url"
	file_string = f.read
end

SCHEDULER.every '2s', first_in: 0 do |job|


# 	file_string = "Country,Network Size,Users
# Afghanistan,0-19,217
# Afghanistan,>=1000,1
# Afghanistan,100-249,25
# Afghanistan,20-99,56
# Afghanistan,250-499,5
# Afghanistan,500-999,1
# Aland Islands,0-19,23
# Aland Islands,100-249,2
# Aland Islands,20-99,3
# Aland Islands,250-499,1"

# file_string = "Country,Network Size,Users
# Afghanistan,0-19,217
# Afghanistan,>=1000,1
# Afghanistan,100-249,25
# Afghanistan,20-99,56
# Afghanistan,250-499,5
# Afghanistan,500-999,1
# Aland Islands,0-19,23
# Aland Islands,100-249,2
# Aland Islands,20-99,3
# Aland Islands,250-499,1
# Albania,0-19,287
# Albania,>=1000,1
# Albania,100-249,57
# Albania,20-99,118
# Albania,250-499,8
# Albania,500-999,5
# Algeria,0-19,423
# Algeria,>=1000,2
# Algeria,100-249,42
# Algeria,20-99,90
# Algeria,250-499,14
# Algeria,500-999,5"

	data = CSV.parse(file_string, {:headers=> true})
	# @network_sizes = Set.new
	# puts "Data: #{data[0]['Country']} Network size: #{data[0]['Network Size']} Users: #{data[0]['Users']}"

	network_hash = {}

	last_country = ""
	data.each do |line|
		country = line['Country']
		size = line['Network Size']
		users = line['Users'].to_i

		if network_hash[size]
			network_hash[size] = network_hash[size] + users
		else
			network_hash[size] = users

		end


		@network_sizes.add(size)


		if last_country and country != last_country
			# puts "#{country} != #{last_country}"
			@countries.add(country)
			@country_hash[country] = Hash.new
			consolidate_country last_country
		end

		@country_hash[country][size] = users.to_i




		last_country = country


		# puts "Data: #{country} Network size: #{size} Users: #{users}}"

	end
	consolidate_country last_country


	series = []


	 colors = ["#4811AE", "#BE008A", "#104BA9", "#926CD6", "#DF64BD", "#6A93D4"]

	 @network_sizes = Set.new ["0-19", "20-99", "100-249", "250-499", "500-999", ">=1000"] # TODO


	 # @country_hash.keys.each do |country|
	 # 	if @country_hash[country]["0-19"] < 1000 #or @country_hash[country]["0-19"] > 80000
	 # 		@country_hash.delete country
	 # 	end

	 # end

	 data = []




	 @network_sizes.each_with_index do |key, index|
	 	puts "Key: #{key} Value: #{ network_hash[key] }"
	 	# data = [{x: index, y: network_hash[key]}]
	 	# series << {color: colors[index], data: data}
	 	data << {x: index, y: network_hash[key]}

	 end

	 series << {color: colors[0], data: data}

	 series.each do |s|
	 	puts "Series: #{s}\n\n"
	 end



	# @network_sizes.each_with_index do |size, index|
	# 	this_data = []
	# 	i = 0

	# 	@country_hash.keys.each do |country|
	# 		this_data <<  {x: i, y: @country_hash[country][size]}

	# 		i = i+1
	# 	end

	# 	series << {
	# 		        color: colors[index],
	# 		        data:  this_data
	# 		      }



	# 	puts "Network sizes: #{size}"
	# end

	# series.each do |s|
	# 	puts "Series: #{s}\n\n"

	# end



	points = [{ x: 0, y: 40 }, { x: 1, y: 49 }, {x: 2, y: 44}, {x: 3, y: 67}]




	# series = [
 #        {
 #        color: "#fff",
 #        data:  [{ x: 0, y: 40 }, { x: 1, y: 49 }, {x: 2, y: 44}, {x: 3, y: 67}]
 #        },

 #        {
 #          color: "#aaa",
 #          data: [{ x: 0, y: 67 }, { x: 1, y: 44 }, {x: 2, y: 49}, {x: 3, y: 40}]
 #        }
 #      ]

	# puts "Series: #{series[0][:color]}" title: "Title #{i}"
	send_event( 'country-big', {points: points, line: "Set the series #{i}", series: series})
	i = i+1
end

def consolidate_country(country)
	# puts "Consolidating #{country}!"
	if @country_hash[country]
		@network_sizes.each do |size|
			@country_hash[country][size] = 0 if !@country_hash[country][size]
		end		
	end

	
end
