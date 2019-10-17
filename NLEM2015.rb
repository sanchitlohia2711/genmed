require 'open-uri'
require 'byebug'
require "kristin"
require "nokogiri"


PDF_FILE = "NLEM2015.pdf"
HTML_FILE = "NLEM2015.html"
TEXT_FILE = File.open("NLEM2015.txt", "w")

class String
  def is_number?
    true if Float(self.delete(".")) rescue false
  end

  def is_desired_text
    begin
      return [false, ""] if self.length > 500
      return [true, "-"] unless self.scan(/\U+FFE2|-|–/).empty?
      return [self != "2015" && self.is_number?, ""]
    rescue
      byebug
      print 5
    end

  end

  def clean
    gsub!(/[[:space:]]+/, ' ').strip rescue self
  end
end

def is

end

def main
  Kristin.convert(PDF_FILE, HTML_FILE) if not File.file?(HTML_FILE)
  doc = File.open(HTML_FILE)
  noko = Nokogiri::HTML(doc)
  divs = noko.search("div").select{|div| div.attr('class') && div.attr('class')[0] != "t"}
  i = 0
  while i < divs.count
    text = divs[i].text.clean
    desired = text.is_desired_text
    if desired[0]
      if desired[1] == "-"
        puts text
      else
        med_text = []
        4.times do |d|
          med_text << divs[i+d].text.clean
        end
        i += 3
        puts med_text.inspect
        text = med_text.join("$$")
      end
      TEXT_FILE.puts text
      break if text.include? "30.9"
    end
    i += 1
  end
end

main()

# pages = reader.pages
