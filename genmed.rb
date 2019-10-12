require "wombat"
require "byebug"
require 'mechanize'
require 'openssl'


class MyScraper
  include Wombat::Crawler
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  PATH1 = "https://www.medlineindia.com/pharmaindex.htm"
  PATH2 = "https://www.medlineindia.com/generic%20index.html"
  PATH3 = "https://cdscoonline.gov.in/CDSCO/soam/drug_data.jsp"
  SELECTORS = ["//html/body/table/tr[4]/td[3]/table/tr/td", "//span/span/span"]
  TABLE_SELECTOR = [""]
  AGENT = Mechanize.new
  FILE = File.open("genmed.txt", "w")
  FILE2 = File.open("cdscoonline.txt", "w")

  def crawl
    puts "Started Crawling"
    # page = AGENT.get(PATH1)
    # start_crawling(page, 0, 2)

    page = AGENT.get(PATH2)
    start_crawling("", page, 0, 2)
  end

  def start_crawling(anchor_text, page, initial_depth, final_depth)
    if initial_depth == final_depth
      parse_table(page, anchor_text) and return
    end
    initial_depth += 1
    anchors = page.xpath(*SELECTORS).search("a")
    anchors.each do |anchor|
      new_page = Mechanize::Page::Link.new(anchor, AGENT, page).click rescue continue
      start_crawling(anchor.text, new_page, initial_depth, final_depth)
    end
  end

  # parser for PATH1 and PATH2
  def parse_table(page, anchor_text)
    begin
      ""
      FILE.puts anchor_text.gsub(/[[:space:]]+/, ' ').strip
      p anchor_text.gsub(/[[:space:]]+/, ' ').strip
      tds = page.xpath("//html/body/table/tr[4]/td/table/tr").search("td")
      tds = tds[(tds.count % 5)..-1]
      tds.each_slice(5) do |s|
        row = s.map{|w| w.text.gsub(/[[:space:]]+/, ' ').strip}.join("$$")
        p row
        FILE.puts row
      end
    rescue Exception => e
      p "-------------------------> e"
    end
  end

  # links {explore xpath: '/html/body/table/tbody/tr[3]/td[2]' {|e| puts e}}
end

my_cool_scraper = MyScraper.new
my_cool_scraper.crawl