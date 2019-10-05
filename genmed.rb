require "wombat"
require "byebug"
require 'mechanize'


class MyScraper
  include Wombat::Crawler
  BASE_URL = "https://www.medlineindia.com"
  PATH1 = BASE_URL + "/pharmaindex.htm"
  PATH2 = BASE_URL + "generic%20index.html"
  SELECTORS = ["//li/*/a", "//li/a"]
  AGENT = Mechanize.new
  DEPTH = 2

  # def crawl
  #   Wombat.crawl do
  #     base_url BASE_URL
  #     path PATH1

  #     some_data css: "html body > table"
  #     # links do
  #     #   explore xpath: '/html/body/table/tbody/tr[3]/td[2]' do |e|
  #     #     puts e
  #     #   end
  #     # end
  #   end
  # end

  def crawl
    page = AGENT.get(PATH1)
    start_crawling(page , 0)
  end

  def start_crawling(page, depth_counter)
    if depth_counter == DEPTH
      parse_table(page) and return
    end
    depth_counter += 1
    anchors = page.xpath(*SELECTORS)
    anchors.each do |anchor|
      new_page = Mechanize::Page::Link.new(anchor, AGENT, page).click
      start_crawling(new_page, depth_counter)
    end
  end

  def parse_table(page)
    byebug
    print 4
  end

  # links {explore xpath: '/html/body/table/tbody/tr[3]/td[2]' {|e| puts e}}
end

my_cool_scraper = MyScraper.new
my_cool_scraper.crawl