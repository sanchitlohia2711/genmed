require "wombat"
require "byebug"
require 'mechanize'
require 'openssl'


class MyScraper
  include Wombat::Crawler
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  PATH1 = "http://nppaimis.nic.in/nppaprice/newmedicinepricesearch.aspx"
  PATH2 = "https://www.medlineindia.com/generic%20index.html"
  PATH3 = "https://cdscoonline.gov.in/CDSCO/soam/drug_data.jsp"
  SELECTORS = ["//html/body/table/tr[4]/td[3]/table/tr/td", "//span/span/span"]
  TABLE_SELECTOR = [""]
  AGENT = Mechanize.new
  FILE = File.open("genmed.txt", "w")
  FILE2 = File.open("nppaimis.txt", "w")

  def crawl
    puts "Started Crawling"
    # page = AGENT.get(PATH1)
    # start_crawling(page, 0, 2)

    page = AGENT.get(PATH1)
    form = page.form('form1')
    form.field_with(:name => "ddlDosageForm").options[2].click
    button = form.button_with(:value => "Search")
    next_page = AGENT.submit(form, button)

    100.times do |i|
      parse_table(next_page)
      i += 2
      break if i == 88
      form["__EVENTARGUMENT"] = "Page$#{i}"
      button.node["onclick"] = "javascript:__doPostBack('DgFindFormulation','Page$#{i}')"
      puts "==============================================================#{i}"
      next_page = AGENT.submit(form, button)
    end

    byebug
    4
  end

  # parser for PATH1 and PATH2
  def parse_table(next_page)
    begin
      table = next_page.search("#DgFindFormulation")
      trs = table.search("tr")
      tds = trs[1..10].search("td")
      tds.each_slice(9) do |s|
        row = s.map{|w| w.text.gsub(/[[:space:]]+/, ' ').strip}.join("$$")
        p row
        # FILE.puts row
      end
    rescue Exception => e
      byebug
      p "-------------------------> #{e}"
    end
  end

  # links {explore xpath: '/html/body/table/tbody/tr[3]/td[2]' {|e| puts e}}
end

my_cool_scraper = MyScraper.new
my_cool_scraper.crawl