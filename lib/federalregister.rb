require 'json'
require 'nokogiri'
require 'open-uri'
require 'crack'
require 'cobravsmongoose'

# Parse rules, prorules, notices, and presdocs out of XML
def parseXML(xml, month, year)
  temparr = Array.new
  xml.xpath("//RULES").each do |r|
    r.xpath("//RULE").each do |u|
      xhash = CobraVsMongoose.xml_to_hash(u)
      xhash_clean = xhash["RULE"]
      xhash_clean["Type"] = "Rule"
      xhash_clean["Date"] = month.to_s+"/"+year.to_s
      xhash_clean["XML"] = u
      temparr.push(xhash_clean)
    end
  end

  xml.xpath("//PRORULES").each do |p|
    p.xpath("//PRORULE").each do |i|
      xhash = CobraVsMongoose.xml_to_hash(i)
      xhash_clean = xhash["PRORULE"]
      xhash_clean["Type"] = "Proposed Rule"
      xhash_clean["Date"] = month.to_s+"/"+year.to_s
      xhash_clean["XML"] = i
      temparr.push(xhash_clean)
    end
  end

  xml.xpath("//NOTICES").each do |n|
    n.xpath("//NOTICE").each do |i|
      xhash = CobraVsMongoose.xml_to_hash(i)
      xhash_clean = xhash["NOTICE"]
      xhash_clean["Type"] = "Notice"
      xhash_clean["Date"] = month.to_s+"/"+year.to_s
      xhash_clean["XML"] = i
      temparr.push(xhash_clean)
    end
  end

  xml.xpath("//PRESDOCS").each do |n|
    n.xpath("//PRESDOCU").each do |i|
      xhash = CobraVsMongoose.xml_to_hash(i)
      xhash_clean = xhash["PRESDOCU"]
      xhash_clean["Type"] = "Presidential Document"
      xhash_clean["Date"] = month.to_s+"/"+year.to_s
      xhash_clean["XML"] = i
      temparr.push(xhash_clean)
    end
  end

  return temparr
end

def getLinks
  temparr = Array.new
  
  year = 2006
  for i in 1..12
      # Set month string
      m = ""
      if i.to_s.length < 2
        m = "0" + i.to_s
      else
        m = i.to_s
      end
      
      # Get federal registers
      html = Nokogiri::HTML(open("http://www.gpo.gov/fdsys/bulkdata/FR/"+year.to_s+"/"+m))

      month = html.css("table")[0]
      month.css("tr").each do |t|
        link = t.css("td")[0].css("a")[0]
        if link
          path = link["href"]
          if path.include? ".xml"
            # Parse XML
            xml = Nokogiri::XML(open("http://www.gpo.gov/fdsys/"+path))
            temparr.push(parseXML(xml, m, year))
          end
        end
      end
    end

  puts JSON.pretty_generate(temparr)
end

getLinks
