require 'json'
require 'nokogiri'
require 'open-uri'
require 'crack'
require 'cobravsmongoose'

# Get all IDs
# Get full text XML url
# Parse out fields into JSON item/hash
# Save in array

# Also Save-
# Full Text
# Type
# Date/Issue

xml = Nokogiri::XML(open("http://www.gpo.gov/fdsys/bulkdata/FR/2014/07/FR-2014-07-31.xml"))

temparr = Array.new
xml.xpath("//RULES").each do |r|
  r.xpath("//RULE").each do |u|
    xhash = CobraVsMongoose.xml_to_hash(u)
    xhash_clean = xhash["RULE"]
    xhash_clean["Type"] = "Rule"
    xhash_clean["XML"] = u
    temparr.push(xhash_clean)
  end
end

xml.xpath("//PRORULES").each do |p|
  p.xpath("//PRORULE").each do |i|
    xhash = CobraVsMongoose.xml_to_hash(i)
    xhash_clean = xhash["PRORULE"]
    xhash_clean["Type"] = "Proposed Rule"
    xhash_clean["XML"] = i
    temparr.push(xhash_clean)
  end
end

xml.xpath("//NOTICES").each do |n|
  n.xpath("//NOTICE").each do |i|
    xhash = CobraVsMongoose.xml_to_hash(i)
    xhash_clean = xhash["NOTICE"]
    xhash_clean["Type"] = "Notice"
    xhash_clean["XML"] = i
    temparr.push(xhash_clean)
  end
end

xml.xpath("//PRESDOCS").each do |n|
    n.xpath("//PRESDOCU").each do |i|
    xhash = CobraVsMongoose.xml_to_hash(i)
    xhash_clean = xhash["PRESDOCU"]
    xhash_clean["Type"] = "Presidential Document"
    xhash_clean["XML"] = i
    temparr.push(xhash_clean)
  end
end

puts JSON.pretty_generate(temparr)

#year = 2014
#i = 07
#for i in 1..12
 # html = Nokogiri::HTML(open("http://www.gpo.gov/fdsys/bulkdata/FR/"+year.to_s+"/07"))
 # month = html.css("table")[0]
  #month.css("tr").each do |t|
   # link = t.css("td")[0].css("a")[0]
   # if link
    # path = link["href"]
     #if path.include? ".xml"
      # xml = Nokogiri::XML(open("http://www.gpo.gov/fdsys/"+path))
       #puts xml.xpath("//RULES")
     #end
    #end
    # Run xmlTojson
    # Save
    # Generate JSON
  #end
#end


