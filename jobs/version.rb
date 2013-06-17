require 'open-uri'
require 'csv'
require 'set'
require 'rubygems'
require 'nokogiri'     

new_data = {}
SCHEDULER.every '2h', first_in: 0 do |job|
	url = "http://spiceworksdata/stats/versions"
	page = Nokogiri::HTML(open(url))   

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
	new_data = []
	versions.keys.each_with_index do |version, index|
		points << {x: index, y: versions[version]}

		version_label = "#{versions[version]}"
		if versions[version] >= 1000
			short = versions[version] / 1000 # truncate to nearest thousand
			r = versions[version] - short * 1000
			if r > 500
				short = short + 1 # round
			end


			version_label = "#{short}k"

		end
		new_data << {label: "v.#{version} (#{version_label} users)", value: versions[version]}
	end

end



	

SCHEDULER.every '2s', first_in: 0 do |job|
	send_event( 'version', {new_data: new_data})
end
