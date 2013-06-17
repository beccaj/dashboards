require 'open-uri'
require 'csv'
require 'set'
require 'rubygems'
require 'nokogiri'     

url = "http://spiceworksdata/stats/versions"
page = Nokogiri::HTML(open(url))   
# puts "Opened page successfully"

rows = page.css('table.stats tbody tr')
versions = {}

rows.each do |row|
	cells = row.css('td')

	if cells[0] and cells[1]
		version_long = cells[0].text



		version = version_long.split(".")[0] if version_long

		
		version = "1" if version_long.include? "\n"


		users = cells[1].text.to_i
		# puts "Version: #{version_long} Users: #{users}"
		if users > 0
			if versions[version]
				versions[version] = versions[version] + users
			else
				versions[version] = users
			end			
		end


	end

end


points = []
versions.keys.each_with_index do |version, index|
	points << {x: index, y: versions[version]}
end

# puts "Points: #{points}"


# puts "versions: #{versions}"




SCHEDULER.every '2s', first_in: 0 do |job|
	send_event( 'versionbar', {line: "Set the title-old bar graph", points: points})
end