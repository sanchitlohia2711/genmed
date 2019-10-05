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


  def crawl
    puts "Started Crawling"
    # page = AGENT.get(PATH1)
    # start_crawling(page, 0, 2)

    page = AGENT.get(PATH2)
    start_crawling(page, 0, 2)
  end

  def start_crawling(page, initial_depth, final_depth)
    puts page
    if initial_depth == final_depth
      parse_table(page) and return
    end
    initial_depth += 1
    anchors = page.xpath(*SELECTORS).search("a")
    anchors.each do |anchor|
      new_page = Mechanize::Page::Link.new(anchor, AGENT, page).click
      start_crawling(new_page, initial_depth, final_depth)
    end
  end

  def parse_table(page)
    page.xpath("//html/body/table/tr[4]/td/table/tr").each do |s|
      arr = s.text().strip().gsub(/\n\n\s*\n\n/, ",").delete("\n").split(",").map(&:strip).map{|s| s.gsub(/\s\s*/," ")}

      if arr.length != 5
          arr = s.text().strip().gsub(/\n\n\s*/, ",").delete("\n").split(",").map(&:strip).map{|s| s.gsub(/\s\s*/," ")}
      end
      if arr.length != 5
          arr = s.text().strip().gsub(/\n\s*/, ",").delete("\n").split(",").map(&:strip).map{|s| s.gsub(/\s\s*/," ")}
      end
      byebug if arr.length != 5
      puts arr.inspect
    end
  end



  # links {explore xpath: '/html/body/table/tbody/tr[3]/td[2]' {|e| puts e}}
end

my_cool_scraper = MyScraper.new
my_cool_scraper.crawl