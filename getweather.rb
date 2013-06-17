require 'open-uri'
require 'csv'


module STUFF
	def sayhello
		puts "HEllo!"
	end
end

base_path = "/src/dashboard_project/assets/myweather/"



url_start = "http://www.wunderground.com/history/airport/"
airport = "ENBR/"  # "KATT/"
url_end = "/MonthlyHistory.html?format=1"


start_date = 1948
end_date = 2012

current = start_date

while current <= end_date
	month = 1

	while month <= 12

		date = "#{current}/#{month}/13"
		date_string = date.split("/").join("-")

		url = url_start + airport + date + url_end

		file_string = ""
		#puts "About to open file"
		open (url) do |f|
			file_string = f.read
		end

		file_string = file_string.gsub("<br />", "")
		# puts "file_string: #{file_string}"


		filepath = base_path + airport.gsub("/", "-") + date_string + ".txt"

		file = File.open(filepath, "w")
		file.puts file_string
		file.close

		puts "wrote file #{filepath}"

		month = month + 1
	end

	current = current + 1

end


