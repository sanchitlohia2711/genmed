require "wombat"
require "byebug"
require 'mechanize'


class MyScraper
  include Wombat::Crawler
  BASE_URL = "https://www.medlineindia.com"
  # PATH1 = BASE_URL + "/pharmaindex.htm"
  PATH2 = BASE_URL + "/generic%20index.html"
  SELECTORS = ["//html/body/table/tr[4]/td[3]/table/tr/td", "//span/span/span"]
  TABLE_SELECTOR = [""]
  AGENT = Mechanize.new
  FILE = File.open("genmed.txt", "w")

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

  def parse_table(page, anchor_text)
    begin
      ""
      FILE.puts anchor_text.gsub(/[[:space:]]+/, ' ').strip
      p anchor_text.gsub(/[[:space:]]+/, ' ').strip
      tds = page.xpath("//html/body/table/tr[4]/td/table/tr").search("td")
      tds = tds[(tds.count % 5)..-1]
      tds.each_slice(5) do |s|
        row = s.map{|w| w.text.gsub(/[[:space:]]+/, ' ').strip}.join(",")
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