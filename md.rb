require "wombat"
require "byebug"


class MyScraper
	include Wombat::Crawler
	BASE_URL = "https://www.medlineindia.com"
	PATH1 = "/pharmaindex.htm"
	# PATH2 = "generic%20index.html"

	def crawl
		Wombat.crawl do
			base_url BASE_URL
			path PATH1

			some_data css: "html"
			links do
				explore xpath: '/html/body/table/tbody/tr[3]/td[2]' do |e|
					puts e
				end
			end
		end
	end
	# links {explore xpath: '/html/body/table/tbody/tr[3]/td[2]' {|e| puts e}}
end

my_cool_scraper = MyScraper.new
puts my_cool_scraper.crawl