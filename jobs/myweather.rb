require 'open-uri'
require 'csv'
require 'set'
require 'rubygems'
require 'nokogiri'    

new_data = []
i = 1

base_path = "/src/dashboard_project/assets/myweather/"

#CDT,Max TemperatureF,Mean TemperatureF,Min TemperatureF,Max Dew PointF,MeanDew PointF,Min DewpointF,Max Humidity, Mean Humidity, Min Humidity, Max Sea Level PressureIn, Mean Sea Level PressureIn, Min Sea Level PressureIn, Max VisibilityMiles, Mean VisibilityMiles, Min VisibilityMiles, Max Wind SpeedMPH, Mean Wind SpeedMPH, Max Gust SpeedMPH,PrecipitationIn, CloudCover, Events, WindDirDegrees

#colors = ["#4811AE", "#BE008A", "#104BA9", "#926CD6", "#DF64BD", "#6A93D4"]
colors = ["#f00", "#f80", "#ff0", "#8f0", "#0f0","#0f8", "#0ff","#08f", "#00f","#80f", "#f0f", "#f08"]


#filepath = base_path + airport + date + ".txt"

start_date = 1948
end_date = 2012

aves = []

rain_counts = []
x_labels = []

series = []


airport = "ENBR" #KATT
start_month = 6
end_month = 12

month = start_month
index = 0 
while month <= end_month
	aves = []
	rain_counts = []
	current = start_date


	while current <= end_date
		rain_count = 0

		filepath = base_path + "#{airport}-#{current}-#{month}-13.txt"

		file = File.open(filepath, "r")
		file_string = file.read

		data = CSV.parse(file_string, {:headers=> true})

		file.close
		#puts "Headers: #{data.headers}"
		temps = []
		all_temps = []

		total_temp = 0.0
		#puts "Num_temps: #{num_temps}"

		addstring = "#{current}: "


		data.each_with_index do |line, i|

			if i != 0 and line['Max TemperatureF']
				temp = line['Max TemperatureF'].to_i
				total_temp = total_temp + temp

				temps << temp
				# puts "#{line['CDT']}: temperature: #{temp}"		
				#addstring = addstring + ", #{temp}"

				if line[' Events'] =~ /([Rr]ain)|([Tt]hund)/i
					# puts "Events for #{line['CDT']}: #{line[' Events']}"
					rain_count = rain_count + 1
				end		

			end



		end


		# if temps.length > 0
		ave_temp = (total_temp / temps.length).round if temps.length > 0
		aves << ave_temp
		rain_counts << rain_count		
			# x_labels << current.to_s
		# end
		
		current = current + 1

	end

	# puts "Raincounts (#{month}): #{rain_counts}"

	new_data = []

	aves.each_with_index do |ave, i|
		if ave
			new_data << {x: i, y: ave}

		else
			new_data << {x: i, y: 0}

		end
	end


	series << {color: colors[index], data: new_data}

	# puts "Series: #{series}"

	month = month + 1
	index = index + 1
end 


current = start_date

while current <= end_date
	x_labels << "#{current}"
	current = current + 1
end


SCHEDULER.every '2s', first_in: 0 do |job|
	title = "Title ##{i}"
	send_event( 'weather', {title: title, new_data: new_data, series: series, x_labels: x_labels})
	i = i+1
end
