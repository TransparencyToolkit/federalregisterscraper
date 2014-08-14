require 'json'
require 'nokogiri'
require 'open-uri'
require 'crack'

# Get all IDs
# Get full text XML url
# Parse out fields into JSON item/hash
# Save in array

year = 2014
i = 07
#for i in 1..12
  html = Nokogiri::HTML(open("http://www.gpo.gov/fdsys/bulkdata/FR/"+year+"/07"))
  month = html.css("table")[0]
  month.css("tr").each do |t|
    link = t.css("td")[0].css("a")[0]
    if link
     path = link["href"]
     if path.include? ".xml"
       file = Crack::XML.parse(open("http://www.gpo.gov/fdsys/"+path))
       puts JSON.pretty_generate(file)
     end
    end
    # Run xmlTojson
    # Save
    # Generate JSON
  end
#end


