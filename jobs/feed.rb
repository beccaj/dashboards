require 'open-uri'
require 'csv'
require 'set'
require 'rubygems'
require 'nokogiri'  
require 'net/http'
require 'rexml/document'   

url = "http://community.spiceworks.com/feed/global.rss"

new_data = {}
headlines = []
headline = "Headline!!!"

SCHEDULER.every '10m', first_in: 0 do |job|
	puts "about to get xml"
	xml_data = Net::HTTP.get_response(URI.parse(url)).body
	doc = REXML::Document.new(xml_data)
	puts "got xml"
	titles = []
	descriptions = []


	doc.elements.each("rss/channel/item") do |item|
		# puts "Item: #{item.text}"
		elems = item.elements
		title = elems['title'].text
		descr = elems['description'].text
		link = elems['link'].text


		title = "<a href='#{link}'>#{title}</a>"

		puts "\nTitle: #{title}"
		puts "Description: #{descr[0, 50]}"

		limit = 500

		ellips = descr.length > limit ? " ..." : ""
		# headlines << "<span class='headline'>#{title}</span></br><span class='description'>#{descr[0,limit]}#{ellips}</span></br>"

		headlines << {headline: title, description: descr}

		new_data[title] = descr

	end

end



	
SCHEDULER.every '30s', first_in: 0 do |job|
	puts "Sent data"
	send_event( 'feed', {new_data: new_data, title: "In the Community", headlines: headlines, headline: headline} )
end
