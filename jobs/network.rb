require 'open-uri'
require 'csv'
require 'set'
require 'rubygems'
require 'nokogiri'     


i = 1
@network_sizes = Set.new
@country_hash = Hash.new
@countries = Set.new

@graph_data = []
file_string = ""

SCHEDULER.every '2h', first_in: 0 do |job|
	url = 'http://spiceworksdata/users/users_by_country_and_network_size'

	open (url) do |f|
		file_string = f.read
	end


end




SCHEDULER.every '2s', first_in: 0 do |job|
	data = CSV.parse(file_string, {:headers=> true})

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
			@countries.add(country)
			@country_hash[country] = Hash.new
			consolidate_country last_country
		end

		@country_hash[country][size] = users.to_i




		last_country = country



	end
	consolidate_country last_country


	series = []


	 colors = ["#4811AE", "#BE008A", "#104BA9", "#926CD6", "#DF64BD", "#6A93D4"]

	 @network_sizes = Set.new ["0-19", "20-99", "100-249", "250-499", "500-999", ">=1000"] # TODO



	 data = []
	 points = []
	 x_labels = []


	 @network_sizes.each_with_index do |key, index|
	 	data << {x: index, y: network_hash[key]}
	 	points << {x: index, y: network_hash[key]}
	 	x_labels << key

	 end

	 series << {color: colors[0], data: data}

	send_event( 'network', {points: points, line: "Set the series #{i}", series: series, x_labels: x_labels})
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
