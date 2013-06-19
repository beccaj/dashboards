require 'open-uri' 
require 'net/http'
require 'rexml/document'   

url = "http://community.spiceworks.com/feed/global.rss"

new_data = {}
headlines = []
headline = "Headline!!!"

SCHEDULER.every '1m', first_in: 0 do |job|
	xml_data = Net::HTTP.get_response(URI.parse(url)).body
	doc = REXML::Document.new(xml_data)
	titles = []
	descriptions = []
	block = ""

	num_items = 5

	doc.elements.each_with_index("rss/channel/item") do |item, index|
		elems = item.elements
		title = elems['title'].text
		descr = elems['description'].text
		link = elems['link'].text

		date = elems['pubDate'].text
		date.gsub!(/:\d\d [\+-]\d\d\d\d/, "")

		title = "<a href='#{link}'>#{title}</a>"
		limit = 100

		ellips = descr.length > limit ? " ..." : ""
		block << "<span class='description'>#{date}</span></br><span class='headline'>#{title}</span></br><span class='description'>#{descr[0,limit]}#{ellips}</span></br></br></br>"


		headlines << {headline: title, description: descr}

		new_data[title] = descr

		if index >= num_items - 1
			break
		end


	end
	
	send_event( 'feed', {new_data: new_data, title: "In the Community", headlines: headlines, block: block} )
end